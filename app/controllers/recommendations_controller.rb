class RecommendationsController < ApplicationController
  def index
    @recommendations = @restaurant.recommendations
  end

  def new
    @recommendation = @restaurants.recomendations.build
  end

  def create
    @recommendation = @restaurant.recommendations.build(recommendation_params)
    @recommendation.user = current_user

    if @recommendation.save
      redirect_to restaurant_recomendations_path(@restaurant), notice: "Recommendation created successfully"
    else
      render :new
    end
  end

  private

  def recommendation_params
    params.require(:recomendation).permit(:description, :restaurant_tags)
  end
end
