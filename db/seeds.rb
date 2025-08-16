# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb
# Uses local Active Storage (Disk) and attaches 3 images to every Recommendation.

# Make sure in config/environments/development.rb:
#   config.active_storage.service = :local
#
# And in config/storage.yml you have:
#   local:
#     service: Disk
#     root: <%= Rails.root.join("storage") %>

# db/seeds.rb

# --- wipe (simple & explicit) ---
# db/seeds.rb
require "open-uri"

Recommendation.destroy_all
Restaurant.destroy_all
User.destroy_all

# local source images we’ll upload to the current Active Storage service
images_dir = Rails.root.join("app/assets/images")
%w[sushi.jpg mochi.jpg restaurant.jpg].each do |fname|
  path = images_dir.join(fname)
  raise "Missing image file: #{path}" unless File.exist?(path)
end

# upload once, reuse blobs
blobs = {
  sushi: ActiveStorage::Blob.create_and_upload!(
    io: File.open(images_dir.join("sushi.jpg")),
    filename: "sushi.jpg",
    content_type: "image/jpeg",
    identify: false
  ),
  mochi: ActiveStorage::Blob.create_and_upload!(
    io: File.open(images_dir.join("mochi.jpg")),
    filename: "mochi.jpg",
    content_type: "image/jpeg",
    identify: false
  ),
  restaurant: ActiveStorage::Blob.create_and_upload!(
    io: File.open(images_dir.join("restaurant.jpg")),
    filename: "restaurant.jpg",
    content_type: "image/jpeg",
    identify: false
  )
}

puts "Creating users..."
10.times do |i|
  user = User.create!(
    first_name: "First#{i + 1}",
    last_name: "Last#{i + 1}",
    username: "user#{i + 1}",
    email: "user#{i + 1}@example.com",
    password: "password",
    password_confirmation: "password"
  )
end

restaurants = restaurants.map do |r|
  restaurant = Restaurant.find_or_initialize_by(name: r[:name])
  restaurant.address = r[:address]
  restaurant.category = r[:category]
  restaurant.latitude = nil    # force re-geocode
  restaurant.longitude = nil
  restaurant.save!
  restaurant.geocode
  restaurant.save!
  puts "#{restaurant.name} => #{restaurant.latitude}, #{restaurant.longitude}"
  restaurant
end

puts "Creating recommendations..."
restaurants.each do |restaurant|
  users.sample(2).each do |user|
    Recommendation.create!(
      user: user,
      restaurant: restaurant,
      description: "Recommendation by #{user.email} for #{restaurant.name}"
    )
  end
end

  # avatar -> pravatar (goes to Cloudinary if that service is active)
  user.profile_picture.attach(
    io: URI.open("https://i.pravatar.cc/150?u=#{user.id}"),
    filename: "avatar-#{user.id}.jpg",
    content_type: "image/jpeg"
  )
    rec.photos.attach([blobs[:sushi], blobs[:mochi], blobs[:restaurant]])

photos_each = Recommendation.first&.photos&.count || 0
puts "✅ Seeded #{User.count} users, #{Restaurant.count} restaurants, #{Recommendation.count} recommendations (#{photos_each} photos/rec)."

puts "Geocoding restaurants..."
Restaurant.find_each do |restaurant|
  # if restaurant.latitude.blank? || restaurant.longitude.blank?
  if restaurant.address.present?
    restaurant.geocode
    restaurant.save(validate: false)
    puts "Geocoded #{restaurant.name} - lat: #{restaurant.latitude}, lng: #{restaurant.longitude}"
  end
end
puts "Done geocoding!"
  
require 'csv'

# Path to the CSV
csv_path = Rails.root.join('db', 'data', 'Tokyo_Restaurant_Reviews_Tabelog.csv')

unless File.exist?(csv_path)
  puts "CSV file not found at #{csv_path}. Skipping CSV import."
else
  puts "Importing restaurants from CSV..."

  CSV.foreach(csv_path, headers: true) do |row|
    begin
      # Use safe navigation to handle missing columns
      restaurant = Restaurant.create!(
        name: row['name']&.strip || "Unnamed Restaurant",
        address: row['address']&.strip || "No Address",
        opening_hours: row['holiday']&.strip,
        category: row['category']&.strip
      )
      puts "Created restaurant: #{restaurant.name}"
    rescue => e
      puts "Failed to create restaurant from row #{row.inspect}: #{e.message}"
    end
  end

  puts "CSV import complete. Total restaurants: #{Restaurant.count}"
end
