class Restaurant < ApplicationRecord
  # === Active Storage ===
  has_many_attached :photos
  has_one_attached :photo

  # === Associations ===
  has_many :recommendations, dependent: :destroy
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  #has_many :plans, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :saved_by_users, through: :bookmarks, source: :user

  has_many :wishlists, through: :bookmarks

  # === Validations ===
  validates :name, :address, :category, presence: true
end
