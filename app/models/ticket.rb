class Ticket < ApplicationRecord
  belongs_to :item
  belongs_to :user

  include AASM

  validates :serial_number, presence: true, uniqueness: true
  validates :coins, numericality: { greater_than_or_equal_to: 1 }

  before_validation :generate_serial_number, on: :create
  after_create :deduct_coin_from_user

  aasm column: 'state' do
    state :pending, initial: true
    state :won
    state :lost
    state :cancelled

    event :win do
      transitions from: :pending, to: :won
    end

    event :lose do
      transitions from: :pending, to: :lost
    end

    event :cancel do
      transitions from: :pending, to: :cancelled, after: :refund_coin
    end
  end

  def generate_serial_number
    date_part = Time.current.strftime("%y%m%d")

    batch_count = item.batch_count || 1
    batch_count = 1 if batch_count.nil? || batch_count.zero?

    ticket_count = Ticket.where(item_id: item.id, batch_count: batch_count).count + 1
    ticket_number = ticket_count.to_s.rjust(4, '0')

    self.serial_number = "#{date_part}-#{item.id}-#{batch_count}-#{ticket_number}"
  end

  private

  def deduct_coin_from_user
    raise ActiveRecord::Rollback if user.coins < coins

    user.decrement!(:coins, coins)
  end

  def refund_coin
    user.increment!(:coins, coins) if state == 'cancelled'
  end

end
