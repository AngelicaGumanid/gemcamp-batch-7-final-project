class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders

  enum genre: { client: 0, admin: 1 }

  validates :genre, presence: true

  validates :email, presence: true, uniqueness: true
  validates :username, uniqueness: true, allow_blank: true
  validates :phone, phone: true, allow_blank: true
  validates :coins, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_deposit, numericality: { greater_than_or_equal_to: 0 }
  validates :children_members, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  mount_uploader :image, ImageUploader

  has_many :locations, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :winners

  # For admin
  belongs_to :parent, class_name: 'User', optional: true
  has_many :children, class_name: 'User', foreign_key: 'parent_id', dependent: :destroy

  def members_total_deposit
    children_users.sum(&:total_deposit)
  end

  def coins_used_count
    tickets.sum(&:coins)
  end

  private

  def children_users
    User.where(parent_id: id)
  end

  def ticket_coins
    Ticket.where(user_id: user.id).sum(:coins).to_h
  end

end
