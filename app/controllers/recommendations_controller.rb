class RecommendationsController < ApplicationController
  before_action :set_restaurant, exept: [:index]
  def index
    if params[:restaurant_id]
      @restaurant = Restaurant.find(params[:restaurant_id])
      @recommendations = @restaurant.recommendations
    else
      @recommendations = Recommendation.all
    end
  end

  def new
    @recommendation = @restaurant.recommendations.build
  end

  def create
    @recommendation = @restaurant.recommendations.build(recommendation_params)
    @recommendation.user = current_user

    if @recommendation.save
      redirect_to restaurant_recommendations_path(@restaurant), notice: "Recommendation created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def recommendation_params
    params.require(:recommendation).permit(:description, :restaurant_tags)
  end
end
