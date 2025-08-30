class RecommendationTag < ApplicationRecord
  belongs_to :recommendation
  belongs_to :tag
end
