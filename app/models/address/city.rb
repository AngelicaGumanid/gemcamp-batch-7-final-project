class Address::City < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :province
  has_many :barangays
  has_many :locations, class_name: 'Location', foreign_key: 'address_city_id', dependent: :destroy
end
