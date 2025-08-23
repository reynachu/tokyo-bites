class RemoveRestaurantFromWishlists < ActiveRecord::Migration[7.1]
  def change
    remove_reference :wishlists, :restaurant, foreign_key: true, index: true
  end
end
