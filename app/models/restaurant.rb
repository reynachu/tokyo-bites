class Restaurant < ApplicationRecord
  # === Active Storage ===
  has_many_attached :photos

  # === Associations ===
  has_many :recommendations, dependent: :destroy
  has_many :plans, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  has_many :wishlists, through: :bookmarks

  # === Validations ===
  validates :name, :address, :category, presence: true
end
