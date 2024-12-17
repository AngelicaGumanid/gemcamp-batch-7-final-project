class Location < ApplicationRecord
  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_regions_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_provinces_id'
  belongs_to :city, class_name: 'Address::City', foreign_key: 'address_cities_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangays_id'

  enum genre: { home: 0, office: 1 }

  validates :name, :street_address, presence: true
  validates :phone_number, phone: true, allow_blank: true

  validate :user_address_limit, on: :create
  before_save :update_address

  def full_address
    [name, street_address, barangay.name, city.name, province.name, region.name].compact.join(", ")
  end

  private

  # def unique_default_address
  #   if user.locations.where(is_default: true).exists? && persisted?
  #     errors.add(:is_default, 'You already have a default address. Please unset it first or confirm the change.')
  #   end
  # end

  def update_address
    user.locations.where(is_default: true).update_all(is_default: false)
  end

  def user_address_limit
    if user && user.locations.count >= 5
      errors.add(:base, 'User can have a maximum of 5 addresses')
    end
  end

end
