class Item < ApplicationRecord
  include AASM

  belongs_to :category, optional: true
  has_many :tickets, dependent: :restrict_with_error
  has_many :winners

  default_scope { where(deleted_at: nil) }

  enum status: { inactive: 0, active: 1 }
  mount_uploader :image, ImageUploader

  validates :minimum_tickets, numericality: { greater_than_or_equal_to: 1 }
  after_initialize :set_default_batch_count, if: :new_record?

  def destroy
    update(deleted_at: Time.current)
  end

  scope :with_deleted, -> { unscope(where: :deleted_at) }

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
      transitions from: %i[starting paused], to: :cancelled, after: :cancel_associated_tickets
    end

    event :resume do
      transitions from: :paused, to: :starting
    end
  end

  def valid_ticket_count?
    current_batch_tickets = tickets.where(batch_count: batch_count).count
    current_batch_tickets >= minimum_tickets
  end

  def pick_winner_and_update_tickets
    return if tickets.empty?

    winning_ticket = tickets.sample
    winning_ticket.update(state: 'won')

    tickets.where.not(id: winning_ticket.id).update_all(state: 'lost')
  end

  private

  def cancel_associated_tickets
    tickets.where(state: 'pending').find_each(&:cancel!)
  end

  def can_start?
    quantity.present? && quantity.positive? && (offline_at.nil? || offline_at > Date.current) && active?
  end

  def deduct_quantity_and_increase_batch
    self.quantity -= 1
    self.batch_count += 1
    save!

    Rails.logger.info("Creating new tickets for batch count: #{batch_count}")

    self.quantity.times do
      tickets.create(state: 'pending', batch_count: batch_count, user_id: nil)
    end
  end

  def set_default_batch_count
    self.batch_count ||= 0
  end

end
