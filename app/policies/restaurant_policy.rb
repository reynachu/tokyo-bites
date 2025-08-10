class RestaurantPolicy < ApplicationPolicy
  def show?
    true # or add your real permission logic here
  end
end
