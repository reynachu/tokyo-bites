class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: :show

  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    # @recommendations = @restaurant.recommendations
    # added a more efficient way to get both recommendations and associated users in one go?
    @recommendations = @restaurant.recommendations.includes(:user).order(created_at: :desc)
    authorize @restaurant
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
