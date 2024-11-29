class Offer < ApplicationRecord
  enum status: { inactive: 0, active: 1 }

  validates :name, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :coin, numericality: { greater_than: 0 }

  mount_uploader :image, ImageUploader

  scope :search, ->(query) { where('name LIKE ?', "%#{query}%") }
end
