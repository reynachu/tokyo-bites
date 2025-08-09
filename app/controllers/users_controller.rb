class UsersController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized, only: [:profile, :show]

  def profile
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
  end
end
