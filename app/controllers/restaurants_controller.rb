class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: :show
  skip_after_action :verify_authorized, only: [:show]
  skip_after_action :verify_policy_scoped, only: [:index], if: -> { request.format.json? }


  def index
    @restaurants = if params[:q].present?
      Restaurant.where("name ILIKE :query OR address ILIKE :query", query: "%#{params[:q]}%")
    else
      Restaurant.all
    end

    respond_to do |format|
      format.html do
        @markers = @restaurants.map do |restaurant|
          {
            lat: restaurant.latitude,
            lng: restaurant.longitude,
            info_window_html: render_to_string(
              partial: "info_window",
              locals: { restaurant: restaurant}
            )
          }
        end
      end

      format.turbo_stream

      format.json do
        render json: @restaurants.limit(10).select(:id, :name)
      end
    end
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @recommendations = @restaurant.recommendations
                                  .includes(:user)
                                  .with_attached_photos
                                  .order(created_at: :desc)

    # Gather attachments into a single array
    @rec_photos = @recommendations.flat_map { |rec| rec.photos.attachments }

    @markers = [{
      lat: @restaurant.latitude,
      lng: @restaurant.longitude,
      info_window_html: render_to_string(
        partial: "restaurants/info_window",
        locals: { restaurant: @restaurant }
      )
    }]
  end

  def map
    @markers = Restaurant.all.map do |restaurant|
      {
        lat: restaurant.latitude,
        lng: restaurant.longitude
      }
    end
    # @recommendations = @restaurant.recommendations
    # added a more efficient way to get both recommendations and associated users in one go?
    @recommendations = @restaurant.recommendations.includes(:user).order(created_at: :desc)
    authorize @restaurant
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
