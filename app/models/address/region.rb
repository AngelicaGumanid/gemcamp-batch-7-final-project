class Address::Region < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  has_many :provinces
  has_many :locations, class_name: 'Location', foreign_key: 'address_region_id', dependent: :destroy
end
