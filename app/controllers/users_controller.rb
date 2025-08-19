class UsersController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized, only: [:profile, :show]

  def profile
    @user = current_user
  end

  def show
    @user = User.find(params[:id])

    @recommendations = @user.recommendations
                            .includes(:restaurant, :user)
                            .with_attached_photos
                            .order(created_at: :desc)

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
      render partial: "user_profile", locals: { user: @user }, layout: false
    else
      render :show
    end
  end



end
