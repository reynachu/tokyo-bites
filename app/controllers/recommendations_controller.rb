class RecommendationsController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized, only: [:new, :create]
  skip_after_action :verify_policy_scoped, only: [:index]

  before_action :set_recommendation, only: [:destroy, :like, :unlike]

  def new
    @recommendation = Recommendation.new(user: current_user)

    # Pre-fill from query params when coming from restaurant show
    if params[:restaurant_id].present?
      @recommendation.restaurant_id = params[:restaurant_id]
    end

    @prefill_restaurant_name =
      params[:restaurant_name].presence ||
      Restaurant.find_by(id: params[:restaurant_id])&.name
  end

  def create
    @recommendation = Recommendation.new(recommendation_params.merge(user: current_user))

    if @recommendation.restaurant_id.blank?
      flash.now[:alert] = "Please choose a restaurant."
      return render :new, status: :unprocessable_entity
    end

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
    authorize @recommendation
    @recommendation.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "Recommendation deleted." }
      format.turbo_stream
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

  def set_recommendation
    @recommendation = Recommendation.find_by(id: params[:id])
    head :not_found unless @recommendation
  end

  def recommendation_params
    params.require(:recommendation).permit(:description, :restaurant_tags, :restaurant_id, photos: [])
  end

  def render_like_frame
    @recommendation.reload
    render partial: "recommendations/like_frame", locals: { recommendation: @recommendation }
  end
end
