class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum genre: { client: 0, admin: 1 }

  validates :genre, presence: true

  validates :email, presence: true, uniqueness: true
  validates :username, uniqueness: true, allow_blank: true
  validates :phone, phone: { possible: true, types: %i[voip mobile], country: 'PH' }, allow_blank: true
  validates :coins, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_deposit, numericality: { greater_than_or_equal_to: 0 }
  validates :children_members, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  mount_uploader :image, ImageUploader

  has_many :locations, dependent: :destroy

  # For admin
  belongs_to :parent, class_name: 'User', optional: true
  has_many :children, class_name: 'User', foreign_key: 'parent_id', dependent: :destroy
end
