class WishlistsController < ApplicationController
  before_action :set_restaurant, only: [:create, :destroy]

  def index
    # Make sure we apply pundit policy scope

    # @restaurants = policy_scope(current_user.wishlist_restaurants)
    # @bookmarks = @wishlist.bookmarks.include(:restaurant)
    @wishlist   = current_user.first_wishlist   # or however you fetch it
    @bookmarks  = @wishlist.bookmarks.includes(:restaurant)

    # If you want all Restaurants across ALL the user's wishlists:
    @restaurants = policy_scope(current_user.wishlist_restaurants)
    # Or, if you only want this wishlist's restaurants:
    # @restaurants = policy_scope(@wishlist.restaurants)
  end

  def create
    current_user.wishlists.create(restaurant: @restaurant)
    redirect_to @restaurant, notice: "Added to wishlist!"
  end

  def destroy
    wishlist = current_user.wishlists.find_by(restaurant: @restaurant)
    wishlist.destroy if wishlist
    redirect_to @restaurant, notice: "Removed from wishlist."
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
