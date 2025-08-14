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
Recommendation.destroy_all
Restaurant.destroy_all
User.destroy_all

# --- sanity: local source images must exist (we'll upload them to the current service) ---
images_dir = Rails.root.join("app/assets/images")
%w[sushi.jpg mochi.jpg restaurant.jpg].each do |fname|
  path = images_dir.join(fname)
  raise "Missing image file: #{path}" unless File.exist?(path)
end

# --- upload each image ONCE; reuse the blobs for every recommendation ---
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

# --- restaurants ---
restaurants = 5.times.map do |i|
  Restaurant.create!(
    name: "Restaurant #{i + 1}",
    description: "Description for restaurant #{i + 1}",
    address: "123 Main St, City #{i + 1}",
    category: %w[Italian Japanese Mexican French Chinese].sample
  )
end

# --- users + recommendations ---
10.times do |i|
  user = User.create!(
    first_name: "First#{i + 1}",
    last_name: "Last#{i + 1}",
    username: "user#{i + 1}",
    email: "user#{i + 1}@example.com",
    password: "password",
    password_confirmation: "password"
  )

  # avatar -> pravatar (uploads to the current Active Storage service; Cloudinary if enabled)
  user.profile_picture.attach(
    io: URI.open("https://i.pravatar.cc/150?u=#{user.id}"),
    filename: "avatar-#{user.id}.jpg",
    content_type: "image/jpeg"
  )

  2.times do
    restaurant = restaurants.sample
    rec = Recommendation.create!(
      description: "Recommendation by #{user.email} for #{restaurant.name}",
      restaurant_tags: "tag1, tag2",
      restaurant: restaurant,
      user: user
    )

    rec.photos.attach([blobs[:sushi], blobs[:mochi], blobs[:restaurant]])
  end
end

photos_each = Recommendation.first&.photos&.count || 0
puts "✅ Seeded #{User.count} users, #{Restaurant.count} restaurants, #{Recommendation.count} recommendations (#{photos_each} photos/rec)."

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
