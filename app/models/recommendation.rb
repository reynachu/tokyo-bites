class Recommendation < ApplicationRecord
  acts_as_likeable

  belongs_to :user
  belongs_to :restaurant
end
