class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :wishlist]
  skip_after_action :verify_authorized, only: [:profile, :show]

  def profile
    @user = current_user
  end

  # GET /users
  def index
    @users = policy_scope(User)

    if params[:q].present?
      @users = @users.where("username ILIKE ?", "%#{params[:q]}%")
    end

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "users/friend_search_results", locals: { users: @users } }
    end
  end


  def show
    @user = User.find(params[:id])
    @recommendations = @user.recommendations.includes(:restaurant).order(created_at: :desc)

    if turbo_frame_request?
      render partial: "user_profile", locals: { user: @user }, layout: false
    else
      render :show
    end
  end

  def wishlist
   @user = User.find(params[:id])
   @restaurants = policy_scope(@user.wishlist_restaurants)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
