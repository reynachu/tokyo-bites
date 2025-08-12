class SocializationsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_socializable

  def follow
    current_user.follow!(@socializable)
    redirect_to @socializable
  end

  def unfollow
    current_user.unfollow!(@socializable)
    redirect_to @socializable
  end

  private

  def load_socializable
    @socializable = User.find(params[:user_id])
  end
end
