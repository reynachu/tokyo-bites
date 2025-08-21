class RecommendationPolicy < ApplicationPolicy
  def destroy?
    super  # same owner-only check from ApplicationPolicy
  end

  def like?   = user.present?
  def unlike? = user.present?
end
