class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all  # You can adjust this to limit which users are visible
    end
  end

  def follow?
    user.present? && record != user
  end

  def unfollow?
    user.present? && record != user
  end
end
