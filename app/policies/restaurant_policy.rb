class RestaurantPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # Allow all restaurants for now
      scope.all
    end
  end

  def show?
    true
  end
end
