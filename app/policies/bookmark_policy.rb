class BookmarkPolicy < ApplicationPolicy
  # record is a Bookmark
  def create?
    user.present? && record.wishlist.user_id == user.id
  end

  def destroy?
    user.present? && record.wishlist.user_id == user.id
  end

  class Scope < Scope
    def resolve
      # only bookmarks belonging to the user's wishlists
      scope.joins(:wishlist).where(wishlists: { user_id: user.id })
    end
  end
  # def show?
  #   return false unless user.present?

  #   if record.is_a?(Bookmark)
  #     record.user_id == user.id
  #   else
  #     true # allow visiting "show" even without a bookmark
  #   end
  # end

  # def create?
  #   user.present?
  # end

  # def destroy?
  #   user.present? && record.user_id == user.id
  # end
end
