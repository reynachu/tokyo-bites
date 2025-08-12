class UsersController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized, only: [:profile, :show]

  def profile
    @user = current_user
  end

  def show
    @user = User.find(params[:id])

    if turbo_frame_request?
      render partial: "user_profile", locals: { user: @user }, layout: false
    else
      render :show
    end
  end
end
