class Ticket < ApplicationRecord
  belongs_to :item
  belongs_to :user

  include AASM

  validates :serial_number, presence: true, uniqueness: true

  before_validation :generate_serial_number, on: :create

  aasm column: 'state' do
    state :pending, initial: true
    state :won, :lost, :cancelled

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

    batch_count = item.batch_count
    batch_count = 1 if batch_count.nil? || batch_count.zero?

    number_count = Ticket.where(item_id: item.id, batch_count: batch_count).count + 1
    number_count = number_count.to_s.rjust(4, '0')

    self.serial_number = "#{date_part}-#{item.id}-#{batch_count}-#{number_count}"
  end

  private

  def refund_coin
    user.decrement!(:coins, 1) if user.coins > 0
  end

end
