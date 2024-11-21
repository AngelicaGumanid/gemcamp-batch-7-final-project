class Category < ApplicationRecord
  has_many :items

  default_scope { where(deleted_at: nil) }
  scope :with_deleted, -> { unscope(where: :deleted_at) }

  validates :name, presence: true, uniqueness: true

  before_destroy :ensure_no_items

  def destroy
    if ensure_no_items
      update(deleted_at: Time.current)
    else
      false
    end
  end

  private

  def ensure_no_items
    if items.exists?
      errors.add(:base, "Cannot delete category with associated items")
      false
    else
      true
    end
  end
end
