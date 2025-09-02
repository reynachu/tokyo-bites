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
  base = Recommendation.includes(:user, restaurant: :saved_by_users, photos_attachments: [blob: [variant_records: {image_attachment: :blob}]])
  @wishlists = current_user&.wishlists || []

  @recommendations =
    if current_user # when logged in
      base.followed_first(current_user).limit(50)
    else # when logged out
      base.order(created_at: :desc).limit(20)
    end

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
      # Show markets for restaurants even if no recommendations if a user does a search
      @restaurants = Restaurant.where("name ILIKE ?", "%#{params[:q]}%")
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
    else
      followees = current_user.followees(User)
      # Get restaurants that have at least one recommendation from a followee
      @recommendations = Recommendation.includes(:restaurant, :user, photos_attachments: :blob)
                                       .where(user_id: followees.pluck(:id))

      @markers = @recommendations.map do |recommendation|
        {
          lat: recommendation.restaurant.latitude,
          lng: recommendation.restaurant.longitude,
            info_window_html: render_to_string(
              partial: "restaurants/info_window",
              locals: { recommendation: recommendation }
            )
        }
      end
    end

    respond_to do |format|
      format.html # normal full-page load
      format.turbo_stream # for turbo updates
    end
  end
end
