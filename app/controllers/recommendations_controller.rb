class RecommendationsController < ApplicationController
  def index
    @recommendations = Recommendation.all
  end

  def recommendation_params
    params.require(:recomendation).permit(:description, :photos, :restaurant_tags)
  end
end
