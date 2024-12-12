class NewsTicker < ApplicationRecord
  belongs_to :admin, class_name: 'User'

  enum status: { inactive: 0, active: 1 }

  validates :content, presence: true

end
