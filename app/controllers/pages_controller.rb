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
    if params[:q].present?
      @restaurants = Restaurant.where("name ILIKE ?", "%#{params[:q]}%")
    else
      followees = current_user.followees(User)
      # Get restaurants that have at least one recommendation from a followee
      @restaurants = Restaurant.joins(:recommendations)
                              .where(recommendations: { user_id: followees.pluck(:id) })
                              .distinct
    end

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

    respond_to do |format|
      format.html # normal full-page load
      format.turbo_stream # for turbo updates
    end
  end
end
