class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  # def home
  #   # TODO: Replace with actual friends logic later
  #   friend_ids = current_user&.friends&.pluck(:id) || []

  #   if friend_ids.any?
  #     @recommendations = Recommendation.where(user_id: friend_ids).order(created_at: :desc)
  #   else
  #     # Placeholder: nearest users — this will change once you add location
  #     @recommendations = Recommendation.limit(20).order(created_at: :desc)
  #   end
  # end

  def home
    # For now, just show all recommendations until friends feature is ready
    @recommendations = Recommendation
      .includes(:user, :restaurant) # avoids N+1 queries
      .order(created_at: :desc)
      .limit(20)

    if turbo_frame_request?
      render partial: "pages/recommendations_feed",
            locals: { recommendations: @recommendations },
            layout: false
    else
      render :home
    end
  end

  def map
    @restaurants = Restaurant.all

    @markers = @restaurants.map do |restaurant|
    {
      lat: restaurant.latitude,
      lng: restaurant.longitude,
      info_window_html: render_to_string(
        partial: "restaurants/info_window",
        locals: { restaurant: restaurant }
      )
    }
    end
  end
end
