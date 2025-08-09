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
    @recommendations = Recommendation.order(created_at: :desc).limit(20)
  end

  def map
  end
end
