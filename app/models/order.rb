class Order < ApplicationRecord
  belongs_to :user
  belongs_to :offer, optional: true

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  include AASM

  validates :serial_number, presence: true, uniqueness: true
  validates :genre, presence: true

  before_validation :generate_serial_number, on: :create
  after_save :update_user_balance, if: :saved_change_to_state?

  aasm column: 'state' do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: :pending, to: :cancelled, after: :handle_cancel
      transitions from: :submitted, to: :cancelled, after: :handle_cancel
    end

    event :pay do
      transitions from: :submitted, to: :paid, after: :handle_payment
    end
  end

  def generate_serial_number
    date_part = Time.current.strftime("%y%m%d")
    number_count = Order.where("created_at >= ?", Time.current.beginning_of_day).count + 1
    number_count = number_count.to_s.rjust(4, '0')
    self.serial_number = "#{date_part}-#{user.id}-#{number_count}"
  end

  def can_pay?
    state == 'submitted' && amount > 0
  end

  def can_cancel?
    state == 'pending' || state == 'submitted'
  end

  private

  def update_user_balance
    case genre
    when 'deposit'
      user.increment!(:coins, coin) if state == 'paid'
    when 'increase'
      user.increment!(:coins, coin) if state == 'paid'
    when 'deduct'
      user.decrement!(:coins, coin) if state == 'paid'
    when 'bonus'
      user.increment!(:coins, coin) if state == 'paid'
    when 'share'
      user.increment!(:coins, coin) if state == 'paid'
    end
  end

  def handle_cancel
    if genre != 'deduct'
      user.increment!(:coins, coin) if user.coins >= coin
    else
      user.decrement!(:coins, coin)
    end
    update_total_deposit if genre == 'deposit'
  end

  def handle_payment
    if genre == 'deposit'
      update_total_deposit
    end
  end

  def update_total_deposit
    if genre == 'deposit'
      user.increment!(:total_deposit, amount || 0)
    end
  end
end
