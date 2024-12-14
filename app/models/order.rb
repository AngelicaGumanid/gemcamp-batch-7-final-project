class Order < ApplicationRecord
  belongs_to :user
  belongs_to :offer, optional: true

  validates :serial_number, presence: true, uniqueness: true
  # validates :remarks, presence: true
  validates :genre, presence: true
  validate :offer_required_if_deposit, if: :deposit?
  validate :amount_and_coins_required_if_deposit, if: :deposit?

  before_validation :generate_serial_number, on: :create
  after_save :update_user_balance, if: :saved_change_to_state?

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  scope :filter_by_serial, -> (serial_number) { where("serial_number LIKE ?", "%#{serial_number}%") }
  scope :filter_by_user_email, -> (email) { joins(:user).where("users.email LIKE ?", "%#{email}%") }
  scope :filter_by_state, -> (state) { where(state: state) }
  scope :filter_by_offer, -> (offer_id) { where(offer_id: offer_id) }
  scope :filter_by_date_range, -> (start_date, end_date) {
    start_date = Date.parse(start_date) if start_date.present?
    end_date = Date.parse(end_date) if end_date.present?
    where(created_at: start_date..end_date) if start_date && end_date
  }

  include AASM

  aasm column: 'state' do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted, :paid], to: :cancelled, after: :handle_cancel
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

  def may_submit?
    state == 'pending'

  end

  def can_pay?
    state == 'submitted' && amount > 0
  end

  def can_cancel?
    state == 'pending' || state == 'submitted' || state == 'paid'
  end

  private

  def handle_payment
    if genre == 'deduct'
      decrease_user_coins(coin)
    else
      increase_user_coins(coin)
    end
    increase_total_deposit if genre == 'deposit'
  end

  def handle_cancel
    if genre == 'deduct'
      increase_user_coins(coin)
    else
      decrease_user_coins(coin) if user.coins >= coin
    end
    decrease_total_deposit if genre == 'deposit'
  end

  def increase_total_deposit
    user.increment!(:total_deposit, amount || 0)
  end

  def decrease_total_deposit
    user.decrement!(:total_deposit, amount || 0)
    genre
  end

  def increase_user_coins(coin)
    user.increment!(:coins, coin)
  end

  def decrease_user_coins(coin)
    if user.coins >= coin
      user.decrement!(:coins, coin)
    else
      raise "Insufficient coins to perform deduction."
    end
  end

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

  # def update_total_deposit
  #   if genre == 'deposit'
  #     user.increment!(:total_deposit, amount || 0)
  #   end
  # end

  def offer_required_if_deposit
    if genre == 'deposit' && offer.nil?
      errors.add(:offer, "must be present for deposit orders.")
    end
  end

  def amount_and_coins_required_if_deposit
    if genre == 'deposit'
      if amount.nil? || amount <= 0
        errors.add(:amount, "must be present and greater than 0 for deposit orders.")
      end
      if coin.nil? || coin <= 0
        errors.add(:coin, "must be present and greater than 0 for deposit orders.")
      end
    end
  end

end
