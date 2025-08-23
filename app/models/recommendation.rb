class Recommendation < ApplicationRecord
  # === Active Storage ===
  has_many_attached :photos
  acts_as_likeable

  belongs_to :user
  belongs_to :restaurant

 # Show posts from the viewer and people they follow first (newest first),
  # then everyone else (newest first).
  scope :followed_first, ->(viewer) {
    return order(created_at: :desc) unless viewer

    joins(:user).order(
      Arel.sql(<<~SQL.squish),
        CASE
          WHEN EXISTS (
            SELECT 1 FROM follows
            WHERE follows.follower_id     = #{viewer.id}
              AND follows.follower_type   = 'User'
              AND follows.followable_type = 'User'
              AND follows.followable_id   = users.id
          )
          OR users.id = #{viewer.id}
          THEN 0 ELSE 1
        END ASC
      SQL
      created_at: :desc
    )
  }
end
