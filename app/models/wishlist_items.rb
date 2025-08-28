class WishlistItem < ApplicationRecord
  belongs_to :wishlist
  belongs_to :restaurant
end
