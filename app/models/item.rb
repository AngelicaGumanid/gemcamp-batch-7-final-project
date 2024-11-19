class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  enum status: { inactive: 0, active: 1 }
  mount_uploader :image, ImageUploader

  def destroy
    update(deleted_at: Time.current)
  end

  scope :with_deleted, -> { unscope(where: :deleted_at) }

end
