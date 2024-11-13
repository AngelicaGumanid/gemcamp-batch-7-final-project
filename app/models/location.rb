class Location < ApplicationRecord
  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_regions_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_provinces_id'
  belongs_to :city, class_name: 'Address::City', foreign_key: 'address_cities_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangays_id'

  enum genre: { home: 0, office: 1 }

  validates :name, :street_address, presence: true
  validates :phone_number, phone: { possible: true, types: %i[voip mobile], country: 'PH' }, allow_blank: true
  validate :user_address_limit, on: :create

  private

  def user_address_limit
    if user && user.locations.count >= 5
      errors.add(:base, 'User can have a maximum of 5 addresses')
    end
  end
end
