class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  acts_as_followable
  acts_as_follower
  acts_as_liker
  acts_as_mentionable

  has_many :recommendations, dependent: :destroy
  has_one_attached :profile_picture
  #has_many :bookmarks, dependent: :destroy
  #has_many :wishlists, through: :bookmarks

  validates :first_name, :last_name, :email,:username, presence: true
  validates :email, :username, uniqueness: true
end
