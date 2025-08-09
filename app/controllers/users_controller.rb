class UsersController < ApplicationController
  before_action :authenticate_user!

  def profile
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
  end
end
