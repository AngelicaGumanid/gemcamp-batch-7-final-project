class Winner < ApplicationRecord
  belongs_to :item
  belongs_to :ticket
  belongs_to :user
  belongs_to :location
  belongs_to :admin, class_name: 'User'

  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :paid_at, presence: true, if: :paid?
  validates :picture, presence: true, if: :shared?
  validates :comment, presence: true, if: :shared?

  mount_uploader :picture, ImageUploader

  include AASM

  aasm column: 'state' do
    state :won, initial: true
    state :claimed
    state :submitted
    state :paid
    state :shipped
    state :delivered
    state :shared
    state :published
    state :remove_published

    event :claim do
      transitions from: :won, to: :claimed
    end

    event :submit do
      transitions from: :claimed, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid, after: :mark_as_paid
    end

    event :ship do
      transitions from: :paid, to: :shipped
    end

    event :deliver do
      transitions from: [:shipped, :paid], to: :delivered
    end

    event :share do
      transitions from: :delivered, to: :shared
    end

    event :publish do
      transitions from: [:shared, :remove_published], to: :published
    end

    event :remove_publish do
      transitions from: :published, to: :remove_published
    end
  end

  private

  def mark_as_paid
    self.paid_at = Time.current
  end

end

