class Item < ApplicationRecord
  enum status: { inactive: 0, active: 1 }
  mount_uploader :image, ImageUploader

end
