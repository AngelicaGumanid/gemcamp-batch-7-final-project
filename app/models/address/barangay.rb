class Address::Barangay < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :city
  has_many :locations, class_name: 'Location', foreign_key: 'address_barangay_id', dependent: :destroy
end
