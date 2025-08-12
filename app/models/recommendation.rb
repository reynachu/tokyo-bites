class Recommendation < ApplicationRecord
  # === Active Storage ===
  has_many_attached :photos
  acts_as_likeable

  belongs_to :user
  belongs_to :restaurant
end
