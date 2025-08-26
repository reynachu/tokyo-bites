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
    wishlist = current_user.first_wishlist
    @bookmark = current_user.first_wishlist.bookmarks.find_by(restaurant: @restaurant)
    if @bookmark
      authorize @bookmark
      @bookmark.destroy!
      head :no_content
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

  # skip_before_action :verify_authenticity_token, only: [:create, :destroy]
  # skip_after_action :verify_authorized, only: :show
  # before_action :authenticate_user!
  # before_action :set_restaurant
  # after_action :verify_authorized

  #  def show
  #   @bookmark = current_user.bookmarks.find_by(restaurant: @restaurant)
  #   authorize @bookmark || Bookmark
  #  end

  # def create
  #   wishlist = current_user.first_wishlist
  #   restaurant = Restaurant.find(params[:restaurant_id])
  #   bookmark = wishlist.bookmark.find_or_initialize_by(restaurant: restaurant)
  #   authorize @bookmark
  #   # @bookmark = current_user.bookmarks.new(restaurant: @restaurant)
  #    if bookmark.persisted? || bookmark.save
  #     head :no_content # 204 (your JS checks for this)
  #   else
  #     render json: { errors: bookmark.errors.full_messages }, status: :unprocessable_entity
  #   end
  #   # authorize @bookmark

  #   # raise

  #   @bookmark.save
  #     # respond_to do |format|
  #     #   format.html { redirect_to @restaurant, notice: "'#{@restaurant.name}' was bookmarked." }
  #     #   format.turbo_stream do
  #     #     render turbo_stream: [
  #     #       turbo_stream.replace(dom_id(@restaurant, :bookmark)) {
  #     #         view_context.link_to restaurant_bookmark_path(@restaurant),
  #     #                              method: :delete,
  #     #                              data: { turbo_frame: dom_id(@restaurant, :bookmark) },
  #     #                              class: "text-danger text-decoration-none",
  #     #                              title: "Remove from Wishlist" do
  #     #           view_context.content_tag(:i, "", class: "fa-solid fa-bookmark fa-lg")
  #     #         end
  #     #       },
  #     #       turbo_stream.replace("flash") {
  #     #         view_context.content_tag(:div, "Restaurant saved to wishlist!", class: "alert alert-success")
  #     #       }
  #     #     ]
  #     #   end
  #     # end
  #   # else
  #   #   redirect_to @restaurant, alert: "Could not bookmark '#{@restaurant.name}'."
  #   # end
  # end

  # def destroy
  #   # @bookmark = current_user.bookmarks.find_by(restaurant: @restaurant)
  #   wishlist = current_user.first_wishlist
  #   bookmark = wishlist.bookmarks.find_by!(restaurant: @restaurant)
  #   authorize @bookmark
  #   bookmark.destroy!
  #   # @bookmark = current_user.first_wishlist.bookmarks.find(params[:id])
  #   # @bookmark.destroy
  #   head :no_content

  #   # respond_to do |format|
  #   #   format.html { redirect_to @restaurant, notice: "'#{@restaurant.name}' was unbookmarked." }
  #   #   format.turbo_stream do
  #   #     render turbo_stream: [
  #   #       turbo_stream.replace(dom_id(@restaurant, :bookmark)) {
  #   #         view_context.link_to restaurant_bookmark_path(@restaurant),
  #   #                              method: :post,
  #   #                              data: { turbo_frame: dom_id(@restaurant, :bookmark) },
  #   #                              class: "text-primary text-decoration-none",
  #   #                              title: "Save to Wishlist" do
  #   #           view_context.content_tag(:i, "", class: "fa-regular fa-bookmark fa-lg")
  #   #         end
  #   #       },
  #   #       turbo_stream.replace("flash") {
  #   #         view_context.content_tag(:div, "Restaurant removed from wishlist!", class: "alert alert-success")
  #   #       }
  #   #     ]
  #   #   end
  #   # end
  # end

  # private

  # def set_restaurant
  #   @restaurant = Restaurant.find(params[:restaurant_id])
  # end
