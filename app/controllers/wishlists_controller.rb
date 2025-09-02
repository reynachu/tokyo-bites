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
   if params[:wishlist_ids].present?
      # Find the selected wishlists
      selected_wishlists = current_user.wishlists.where(id: params[:wishlist_ids])

      # Associate the restaurant with each wishlist, avoiding duplicates
      selected_wishlists.each do |wishlist|
        wishlist.restaurants << @restaurant unless wishlist.restaurants.include?(@restaurant)
      end

      flash[:notice] = "Added to selected wishlists!"
    else
      flash[:alert] = "Please select at least one wishlist."
    end

    redirect_back(fallback_location: @restaurant)
  end

  def destroy
    wishlist = current_user.wishlists.find(params[:wishlist_id])
    restaurant = Restaurant.find(params[:restaurant_id])
    wishlist.restaurants.delete(restaurant)
    redirect_to @restaurant, notice: "Removed from wishlist."
    
    # wishlist = current_user.wishlists.find_by(restaurant: @restaurant)
    # wishlist.destroy if wishlist
    # redirect_to @restaurant, notice: "Removed from wishlist."
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
