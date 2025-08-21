class RecommendationPolicy < ApplicationPolicy
  def destroy?
    super  # same owner-only check from ApplicationPolicy
  end
end
