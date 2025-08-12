class Recommendation < ApplicationRecord
  # === Active Storage ===
  has_many_attached :photos

  belongs_to :user
  belongs_to :restaurant
end
