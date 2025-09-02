class BookmarksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]
  skip_after_action :verify_authorized, only: :show
  before_action :authenticate_user!
  before_action :set_restaurant
  after_action  :verify_authorized

  def show
    @bookmark = current_user.first_wishlist.bookmarks.find_by(restaurant: @restaurant)
    candidate  = @bookmark || current_user.first_wishlist.bookmarks.build(restaurant: @restaurant)
    #authorize candidate
    respond_to do |format|
      format.html # renders show.html.erb
      format.json { render json: { bookmarked: @bookmark.present? } }
    end
  end

  def create
    wishlist = current_user.first_wishlist
    @bookmark = current_user.first_wishlist.bookmarks.find_or_initialize_by(restaurant: @restaurant)
    @bookmark.user = current_user
    authorize @bookmark
    if @bookmark.persisted? || @bookmark.save
      head :no_content
    else
      render json: { errors: @bookmark.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    #wishlist = current_user.first_wishlist
    @bookmark = current_user.first_wishlist.bookmarks.find_by(restaurant: @restaurant)
    if @bookmark
      authorize @bookmark
      @bookmark.destroy!
      if params[:redirect]
        redirect_to wishlists_path
      else
        head :no_content
      end
  # rescue ActiveRecord::RecordNotFound
  #   head :not_found
    else
    skip_authorization  # tell Pundit we intentionally skipped
    head :not_found
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
