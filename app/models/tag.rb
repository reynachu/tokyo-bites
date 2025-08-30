class Tag < ApplicationRecord
  has_and_belongs_to_many :restaurants
  has_many :recommendation_tags, dependent: :destroy
  has_many :recommendations, through: :recommendation_tags
end
