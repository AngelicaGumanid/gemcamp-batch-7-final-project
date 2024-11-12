class Location < ApplicationRecord
  belongs_to :user

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
