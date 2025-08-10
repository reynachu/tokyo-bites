class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: :show

  def index
    @restaurants = Restaurant.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @recommendations = @restaurant.recommendations
    authorize @restaurant
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
end
