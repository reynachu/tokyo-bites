class Bookmark < ApplicationRecord
  belongs_to :wishlist
  belongs_to :restaurant
  belongs_to :user

  validates :wishlist, presence: true
  validates :restaurant, presence: true
  validates :restaurant_id, uniqueness: { scope: :wishlist_id }
  validates :user_id, uniqueness: { scope: :restaurant_id, message: "already bookmarked this restaurant" }
end
