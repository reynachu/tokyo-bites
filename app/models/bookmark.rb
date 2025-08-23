class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  belongs_to :wishlist
  validates :restaurant_id, uniqueness: { scope: :wishlist_id }
  validates :user_id, uniqueness: { scope: :restaurant_id, message: "already bookmarked this restaurant" }
end
