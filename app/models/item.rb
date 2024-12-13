class Item < ApplicationRecord
  belongs_to :category, optional: true
  has_many :tickets, dependent: :restrict_with_error
  has_many :winners

  enum status: { inactive: 0, active: 1 }
  mount_uploader :image, ImageUploader

  validates :name, presence: true, length: { maximum: 255 }
  validates :category_id, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :minimum_tickets, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :online_at, presence: true
  validates :offline_at, presence: true

  attribute :batch_count, :integer, default: 0
  attribute :minimum_tickets, :integer, default: 1

  def destroy
    update(deleted_at: Time.current)
  end

  default_scope { where(deleted_at: nil) }
  scope :with_deleted, -> { unscope(where: :deleted_at) }

  include AASM
  aasm column: 'state' do
    state :pending, initial: true
    state :starting
    state :paused
    state :ended
    state :cancelled

    event :start do
      transitions from: [:pending, :paused, :ended, :cancelled], to: :starting, guard: :can_start?
      after do
        deduct_quantity_and_increase_batch
      end
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended, guard: :valid_ticket_count?
      after do
        pick_winner_and_update_tickets
      end
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled, after: :cancel_associated_tickets
    end

    # event :resume do
    #   transitions from: :paused, to: :starting
    # end
  end

  def can_start?
    quantity&.positive? && (offline_at.nil? || offline_at > Date.current) && active?
  end

  def valid_ticket_count?
    tickets.where(batch_count: batch_count).count >= minimum_tickets
  end

  private

  def deduct_quantity_and_increase_batch
    self.class.transaction do
      decrement!(:quantity)
      increment!(:batch_count)
    end
  end

  def pick_winner_and_update_tickets
    return if tickets.empty?

    current_batch_tickets = tickets.where(batch_count: batch_count)

    Item.transaction do
      winning_ticket = current_batch_tickets.sample
      raise ActiveRecord::Rollback unless winning_ticket

      winning_ticket.update!(state: 'won')
      current_batch_tickets.where.not(id: winning_ticket.id).update_all(state: 'lost')

      create_winner_record(winning_ticket)
    end
  end

  def create_winner_record(winning_ticket)
    user = winning_ticket.user
    admin = User.admin.first
    raise "No admin user found!" unless admin

    location = user.locations.find_by(is_default: true) || user.locations.first
    raise "No location found for user #{user.id}" unless location

    winner = Winner.create(
      item: self,
      ticket: winning_ticket,
      user: user,
      location: location,
      item_batch_count: winning_ticket.batch_count,
      price: calculate_winner_price,
      admin: admin,
      state: 'won'
    )

    if winner.persisted?
      Rails.logger.info("Winner created successfully: #{winner.id}")
    else
      Rails.logger.error("Failed to create winner: #{winner.errors.full_messages.join(', ')}")
      raise ActiveRecord::Rollback, "Winner creation failed."
    end
  end

  def calculate_winner_price
    100.0
  end

  def cancel_associated_tickets
    tickets.pending.find_each(&:cancel!)
  end

end
