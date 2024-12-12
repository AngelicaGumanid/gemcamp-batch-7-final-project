class NewsTicker < ApplicationRecord
  belongs_to :admin, class_name: 'User'

  enum status: { inactive: 0, active: 1 }

  validates :content, presence: true

  default_scope { where(deleted_at: nil) }
  scope :with_deleted, -> { unscope(where: :deleted_at) }

  def destroy
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
  end

end
