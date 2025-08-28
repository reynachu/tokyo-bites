class Wishlist < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :bookmarks, dependent: :destroy
  has_many :restaurants, through: :bookmarks
end
