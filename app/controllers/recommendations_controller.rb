class RecommendationsController < ApplicationController
  # Only set @restaurant when using the nested route (/restaurants/:restaurant_id/recommendations/new)
  before_action :set_restaurant_from_path, if: -> { request.path_parameters[:restaurant_id].present? }
  before_action :authenticate_user!
  skip_after_action :verify_authorized, only: [:new, :create]
  skip_after_action :verify_policy_scoped, only: [:index]

  before_action :set_recommendation, only: [:destroy, :like, :unlike]

  def new
    if @restaurant
      # Nested route -> no dropdown (your existing branch)
      @recommendation = @restaurant.recommendations.build
    else
      # Non-nested route with ?restaurant_id=... -> preselect the dropdown
      @recommendation = Recommendation.new(restaurant_id: params[:restaurant_id])
    end
  end

  def create
    if @restaurant
      @recommendation = @restaurant.recommendations.build(recommendation_params)
    else
      @recommendation = Recommendation.new(recommendation_params)
      # restaurant_id will already be in params from the dropdown
    end
    @recommendation.user = current_user

    if @recommendation.save
      if turbo_frame_request?
        # full-page redirect for Turbo
        redirect_to root_path, notice: "Recommendation created successfully", status: :see_other
      else
        redirect_to root_path, notice: "Recommendation created successfully"
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @recommendation  # Pundit: must be owner per policy
    @recommendation.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "Recommendation deleted." }
      format.turbo_stream # see step 4 for auto-remove
    end
  end

  def like
    authorize @recommendation, :like?
    current_user.like!(@recommendation) unless current_user.likes?(@recommendation)
    render_like_frame
  end

  def unlike
    authorize @recommendation, :unlike?
    current_user.unlike!(@recommendation) if current_user.likes?(@recommendation)
    render_like_frame
  end

  private

  # Use path params to detect nested route; avoids triggering on query string
  def set_restaurant_from_path
    @restaurant = Restaurant.find(request.path_parameters[:restaurant_id])
  end

  def set_recommendation
    @recommendation = Recommendation.find(params[:id])
  end

  def recommendation_params
    params.require(:recommendation).permit(:description, :restaurant_tags, :restaurant_id, photos: [])
  end

  def render_like_frame
    @recommendation.reload
    render partial: "recommendations/like_frame",
           locals: { recommendation: @recommendation }
  end

end
