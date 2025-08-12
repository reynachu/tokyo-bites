class UserPolicy < ApplicationPolicy

  def follow?
    user.present? && record != user
  end

  def unfollow?
    user.present? && record != user
  end
end
