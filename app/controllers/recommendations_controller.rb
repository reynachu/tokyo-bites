class RecommendationsController < ApplicationController
  # Only set @restaurant when using the nested route (/restaurants/:restaurant_id/recommendations/new)
  before_action :set_restaurant_from_path, if: -> { request.path_parameters[:restaurant_id].present? }
  before_action :authenticate_user!
  skip_after_action :verify_authorized, only: [:new, :create]
  skip_after_action :verify_policy_scoped, only: [:index]

  def new
    if @restaurant
      # Nested route -> no dropdown (your existing branch)
      @recommendation = @restaurant.recommendations.build
    else
      # Non-nested route with ?restaurant_id=... -> preselect the dropdown
      @recommendation = Recommendation.new(restaurant_id: params[:restaurant_id])
    end
  end

  def create
    if @restaurant
      @recommendation = @restaurant.recommendations.build(recommendation_params)
    else
      @recommendation = Recommendation.new(recommendation_params)
      # restaurant_id will already be in params from the dropdown
    end
    @recommendation.user = current_user

    if @recommendation.save
      redirect_to restaurant_path(@recommendation.restaurant), notice: "Recommendation created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Use path params to detect nested route; avoids triggering on query string
  def set_restaurant_from_path
    @restaurant = Restaurant.find(request.path_parameters[:restaurant_id])
  end

  def recommendation_params
    params.require(:recommendation).permit(:description, :restaurant_tags, :restaurant_id, photos: [])
  end
end
