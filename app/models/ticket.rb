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
    # Get the current date in yymmdd format
    date_part = Time.current.strftime("%y%m%d")

    # Get the associated item (assuming the ticket belongs to an item)
    item = self.item

    # Ensure batch_count is set. If nil, default to 1 or another value.
    batch_count = item.batch_count || 1

    # Count the number of tickets for the current item and batch (starting from 0001)
    number_count = Ticket.where(item_id: item.id, batch_count: batch_count).count + 1
    number_count = number_count.to_s.rjust(4, '0') # Ensure 4 digits, pad with leading zeros

    # Generate the serial number in the desired format
    serial_number = "#{date_part}-#{item.id}-#{batch_count}-#{number_count}"

    # Return the generated serial number
    serial_number
  end

  private

  def refund_coin
    user.increment!(:coins, 1)
  end

end
