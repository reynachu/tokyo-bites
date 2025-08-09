class RecommendationsController < ApplicationController

  before_action :set_restaurant, if: -> { params[:restaurant_id].present? }
  skip_after_action :verify_authorized, only: [:new, :create]
  skip_after_action :verify_policy_scoped, only: [:index]

  def index
    if params[:restaurant_id]
      @restaurant = Restaurant.find(params[:restaurant_id])
      @recommendations = @restaurant.recommendations
    else
      # Global: /recommendations
      @recommendations = Recommendation.all
    end
  end

  def new
    if @restaurant
      @recommendation = @restaurant.recommendations.build
    else
      @recommendation = Recommendation.new
    end
  end

  def create
    if @restaurant
      @recommendation = @restaurant.recommendations.build(recommendation_params)
    else
      @recommendation = Recommendation.new(recommendation_params)
      @recommendation.restaurant_id = params[:recommendation][:restaurant_id] # from dropdown in form
    end

    @recommendation.user = current_user

    if @recommendation.save
      redirect_to restaurant_recommendations_path(@recommendation.restaurant), notice: "Recommendation created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def recommendation_params
    params.require(:recommendation).permit(:description, :restaurant_tags, :restaurant_id)
  end
end
