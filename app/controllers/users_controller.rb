class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :wishlist, :update, :remove_profile_picture]
  before_action :ensure_owner!, only: [:update, :remove_profile_picture]

  # Pundit verifier skipped for these actions
  skip_after_action :verify_authorized, only: [:profile, :show, :update, :remove_profile_picture]

  def profile
    @user = current_user
  end

  def index
    @users = policy_scope(User)
    @users = @users.where("username ILIKE ?", "%#{params[:q]}%") if params[:q].present?

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "users/friend_search_results", locals: { users: @users } }
    end
  end

  def show
    populate_profile_stats!(@user)

    if turbo_frame_request?
      render partial: "users/user_profile", formats: [:html], locals: { user: @user }, layout: false
    else
      render :show
    end
  end

  def wishlist
    @restaurants = policy_scope(@user.wishlist_restaurants)
  end

  def update
    if @user.update(user_params)
      show_for_frame_or_redirect
    else
      show_for_frame_or_redirect(status: :unprocessable_entity)
    end
  end

  def remove_profile_picture
    @user.profile_picture.purge_later if @user.profile_picture.attached?
    show_for_frame_or_redirect
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def show_for_frame_or_redirect(status: :ok)
    populate_profile_stats!(@user)

    if turbo_frame_request?
      render partial: "users/user_profile",
             formats: [:html],
             locals: { user: @user },
             layout: false,
             status: status
    else
      if status == :ok
        redirect_to @user, notice: "Profile updated."
      else
        render :show, status: status
      end
    end
  end

  # Single source for all profile stats used by the view
  def populate_profile_stats!(user)
    @recommendations = user.recommendations
                           .includes(:restaurant, :user)
                           .with_attached_photos
                           .order(created_at: :desc)

    @places_visited_count = user.recommendations
                                .where.not(restaurant_id: nil)
                                .distinct
                                .count(:restaurant_id)

    resto_counts = user.recommendations
                       .reorder(nil)
                       .where.not(restaurant_id: nil)
                       .group(:restaurant_id)
                       .order(Arel.sql("COUNT(*) DESC"))
                       .limit(5)
                       .count
    @top5_resto_ids = resto_counts.keys
    @top5_restos    = Restaurant.where(id: @top5_resto_ids).index_by(&:id)
    @top5           = @top5_resto_ids.map { |id| [@top5_restos[id], resto_counts[id]] }.reject { |r, _| r.nil? }

    @top_categories = user.recommendations
                          .reorder(nil)
                          .joins(:restaurant)
                          .group("restaurants.category")
                          .order(Arel.sql("COUNT(*) DESC"))
                          .limit(3)
                          .count

    most_counts = user.recommendations
                      .reorder(nil)
                      .where.not(restaurant_id: nil)
                      .group(:restaurant_id)
                      .order(Arel.sql("COUNT(*) DESC"))
                      .limit(3)
                      .count
    @most_revisited_ids = most_counts.keys
    @most_revisited_map = Restaurant.where(id: @most_revisited_ids).index_by(&:id)
    @most_revisited     = @most_revisited_ids.map { |id| [@most_revisited_map[id], most_counts[id]] }.reject { |r, _| r.nil? }
  end

  def ensure_owner!
    redirect_to @user, alert: "Not allowed." unless current_user == @user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :profile_picture)
  end
end
