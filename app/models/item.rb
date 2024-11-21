class Item < ApplicationRecord
  include AASM

  belongs_to :category, optional:true

  default_scope { where(deleted_at: nil) }

  enum status: { inactive: 0, active: 1 }
  mount_uploader :image, ImageUploader

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
      transitions from: [:pending, :ended, :cancelled], to: :starting, guard: :can_start?
      after do
        deduct_quantity_and_increase_batch
      end
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end

    event :resume do
      transitions from: :paused, to: :starting
    end
  end

  def can_start?
    quantity.present? && quantity.positive? && (offline_at.nil? || offline_at > Date.current) && active?
  end

  def deduct_quantity_and_increase_batch
    self.quantity -= 1
    self.batch_count += 1
    save!
  end

end
