class SearchController < ApplicationController
  skip_after_action :verify_policy_scoped, only: :index

  def index
    query = params[:q]

    # Search friends
    @users = if query.present?
      User.where("username ILIKE ?", "%#{query}%")
    else
      User.none
    end

    # Search restaurants
    @restaurants = if query.present?
      Restaurant.where("name ILIKE :query OR address ILIKE :query", query: "%#{query}%")
    else
      Restaurant.none
    end

    respond_to do |format|
      format.text
      format.html
    end
  end
end
