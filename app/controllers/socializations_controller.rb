class SocializationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_socializable

  def follow
    authorize @user, :follow?
    current_user.follow!(@user)
    redirect_to @user
  end

  def unfollow
    authorize @user, :unfollow?
    current_user.unfollow!(@user)
    redirect_to @user
  end

  private

  def load_socializable
    @user = User.find(params[:user_id])
  end
end
