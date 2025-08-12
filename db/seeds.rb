# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.destroy_all
Restaurant.destroy_all
Recommendation.destroy_all

restaurants = []
5.times do |i|
  restaurants << Restaurant.create!(
    name: "Restaurant #{i + 1}",
    description: "Description for restaurant #{i + 1}",
    address: "123 Main St, City #{i + 1}",
    category: ["Italian", "Japanese", "Mexican", "French", "Chinese"].sample
  )
end

10.times do |i|
  user = User.create!(
    first_name: "First#{i + 1}",
    last_name: "Last#{i + 1}",
    username: "user#{i + 1}",
    email: "user#{i + 1}@example.com",
    password: "password",
    password_confirmation: "password"
  )

  2.times do
    restaurant = restaurants.sample
    Recommendation.create!(
      description: "Recommendation by #{user.email} for #{restaurant.name}",
      restaurant_tags: "tag1, tag2",
      restaurant: restaurant,
      user: user
    )
  end
end

puts "Seeded #{User.count} users, #{Restaurant.count} restaurants, and #{Recommendation.count} recommendations."

# require 'csv'

# csv_path = Rails.root.join('db', 'data', 'Tokyo_Restaurant_Reviews_Tabelog.csv')

# CSV.foreach(csv_path, headers: true) do |row|
#   Restaurant.create!(
#     name: row['name']&.strip,
#     address: row['address']&.strip,
#     opening_hours: row['holiday']&.strip, # Consider renaming later
#     category: row['genre']&.strip
#   )
# end


# map
puts "Geocoding restaurants..."

Restaurant.find_each do |restaurant|
  if restaurant.latitude.blank? || restaurant.longitude.blank?
    if restaurant.address.present?
      restaurant.geocode
      restaurant.save(validates: false) # skip validations if needed
      puts "Geocode #{restaurant.name} - lat: #{restaurant.latitude}, lng: #{restaurant.longitude}"
    else
      puts "No address for #{restaurant.name}, skipping..."
    end
      puts "Coordinates already set for #{restaurant.name}, skipping..."
  end
end

puts "Done geocoding!"
