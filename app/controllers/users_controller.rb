class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :wishlist]
  skip_after_action :verify_authorized, only: [:profile, :show]
  skip_after_action :verify_authorized, only: [:profile, :show, :edit, :update, :remove_profile_picture]
  before_action :set_user, only: [:show, :edit, :update, :remove_profile_picture]
  before_action :ensure_owner!, only: [:edit, :update, :remove_profile_picture]


  def profile
    @user = current_user
  end

  # GET /users
  def index
    @users = policy_scope(User)
    @users = @users.where("username ILIKE ?", "%#{params[:q]}%") if params[:q].present?

    respond_to do |format|
      format.html
      format.turbo_stream { render partial: "users/friend_search_results", locals: { users: @users } }
    end
    # @users = policy_scope(User)

    # if params[:q].present?
    #   @users = @users.where("username ILIKE ?", "%#{params[:q]}%")
    # end

    # respond_to do |format|
    #   format.html
    #   format.turbo_stream { render partial: "users/friend_search_results", locals: { users: @users } }
    # end
  end


  def show
    @user = User.find(params[:id])

    @recommendations = @user.recommendations
                            .includes(:restaurant, :user)
                            .with_attached_photos
                            .order(created_at: :desc)

    # total number of restaurants visited
    @places_visited_count = @user.recommendations.where.not(restaurant_id: nil).distinct.count(:restaurant_id)

    # Top 5 restaurants by rec count
    resto_counts    = @user.recommendations
                          .reorder(nil)                        # clear ORDER BY created_at
                          .where.not(restaurant_id: nil)
                          .group(:restaurant_id)
                          .order(Arel.sql("COUNT(*) DESC"))
                          .limit(5)
                          .count
    @top5_resto_ids = resto_counts.keys
    @top5_restos    = Restaurant.where(id: @top5_resto_ids).index_by(&:id)
    @top5           = @top5_resto_ids.map { |id| [@top5_restos[id], resto_counts[id]] }.reject { |r, _| r.nil? }

    # Top 3 categories
    @top_categories = @user.recommendations
                          .reorder(nil)                        # clear ORDER BY created_at
                          .joins(:restaurant)
                          .group("restaurants.category")
                          .order(Arel.sql("COUNT(*) DESC"))
                          .limit(3)
                          .count

    # Most revisited (top 3 restaurants by this user's rec count)
    most_counts         = @user.recommendations
                              .reorder(nil)                   # clear ORDER BY created_at
                              .where.not(restaurant_id: nil)
                              .group(:restaurant_id)
                              .order(Arel.sql("COUNT(*) DESC"))
                              .limit(3)
                              .count
    @most_revisited_ids = most_counts.keys
    @most_revisited_map = Restaurant.where(id: @most_revisited_ids).index_by(&:id)
    @most_revisited     = @most_revisited_ids.map { |id| [@most_revisited_map[id], most_counts[id]] }
                                            .reject { |r, _| r.nil? }

    if turbo_frame_request?
      render partial: "users/user_profile", formats: [:html], locals: { user: @user }, layout: false
    else
      render :show
    end
  end

  def wishlist
    @user = User.find(params[:id])
    @restaurants = policy_scope(@user.wishlist_restaurants)
  end

  def edit
    # Optional: render a dedicated edit screen, or keep inline form on show
    # render :edit
  end

  def update
    if @user.update(user_params)
      # rebuild any collections your partial expects (or call a helper if you made one)
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
  # rebuild collections here just like in `show` (or refactor to a shared method)
  @recommendations = @user.recommendations
                          .includes(:restaurant, :user)
                          .with_attached_photos
                          .order(created_at: :desc)
  # ... compute @top5, @top_categories, @most_revisited exactly as in `show` ...

  if turbo_frame_request?
    render partial: "users/user_profile", formats: [:html], locals: { user: @user }, layout: false, status: status
  else
    if status == :ok
      redirect_to @user, notice: "Profile updated."
    else
      render :show, status: status
    end
  end
end

  # Simple owner guard. If you use Pundit, replace with `authorize @user`.
  def ensure_owner!
    redirect_to @user, alert: "Not allowed." unless current_user == @user
  end

  # Permit names, username, and profile picture
  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :profile_picture)
  end
end
