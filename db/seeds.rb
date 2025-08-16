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

puts "Creating users..."
users = 10.times.map do |i|
  User.create!(
    first_name: "First#{i + 1}",
    last_name: "Last#{i + 1}",
    username: "user#{i + 1}",
    email: "user#{i + 1}@example.com",
    password: "password",
    password_confirmation: "password"
  )
end

# puts "Seeded #{User.count} users, #{Restaurant.count} restaurants, and #{Recommendation.count} recommendations."

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
# restaurants = [
#   { name: "APA Hotel Iidabashi Ekimae", address: "3-4-6 Iidabashi, Chiyoda-ku, Tokyo", category: "others" },
#   { name: "Ittengo", address: "3-3-7 Iidabashi, Chiyoda-ku, Tokyo", category: "Dining bar" },
#   { name: "Bento Market", address: "Sunpark Mansion Chiyoda 1F, 2-9-4 Iidabashi, Chiyoda-ku, Tokyo", category: "Bento" },
#   { name: "Iidabashi DELHI", address: "Tosendo Building 1F, 1-5-7 Iidabashi, Chiyoda-ku, Tokyo", category: "Bento" },
#   { name: "Bento 168 Iidabashi", address: "Sunpark Mansion Chiyoda 1F, 2-9-4 Iidabashi, Chiyoda-ku, Tokyo", category: "Bento" },
#   { name: "Chiyoda Millet", address: "1F Human Resources Development Building, 2-11-5 Iidabashi, Chiyoda-ku, Tokyo", category: "Bento" },
#   { name: "Cote d'Azur Iidabashi Station Store", address: "4th Yamasho Building, 4-8-2 Iidabashi, Chiyoda-ku, Tokyo, 4th and 5th floors", category: "Italian" },
#   { name: "Hoshino Iidabashi, a private room izakaya serving local chicken", address: "3-10-9 Iidabashi, Chiyoda-ku, Tokyo, 3F", category: "Tempura, Izakaya" },
#   { name: "Family Mart Kanda Iwamotocho 1-chome Store", address: "1-3-1 Iwamotocho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Seven-Eleven Chiyoda Iwamotocho 2-chome Store", address: "2-18-1 Iwamotocho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Chinese Izakaya Noble", address: "1-12-11 Iwamotocho, Chiyoda-ku, Tokyo", category: "Chinese cuisine" },
#   { name: "Doutor Coffee Shop Iwamotocho 2-chome Branch", address: "Igeta Building 1F, 2-8 Iwamotocho, Chiyoda-ku, Tokyo", category: "Cafes and coffee" },
#   { name: "Lawson Iwamotocho 3-chome store", address: "3-7-16 Iwamotocho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Ministop Iwamotocho 2-chome store", address: "2-6-10 Iwamotocho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Izakaya Mogumogu Kanda West Exit Branch", address: "Ohara 6th Building 2F, 3-9-6 Uchikanda, Chiyoda-ku, Tokyo", category: "Izakaya, Yakitori" },
#   { name: "Creative Japanese Cuisine x Private Room Izakaya Torimasa Kanda Station Front Store", address: "4F, 108 Tokyo Building, 3-20-6 Uchikanda, Chiyoda-ku, Tokyo", category: "Izakaya, Japanese" },
#   { name: "FUMA", address: "Watanabe Jyukken Building 2F, 3-12-5 Uchikanda, Chiyoda-ku, Tokyo", category: "Izakaya" },
#   { name: "Irish Pub Peter Cole Kanda Branch", address: "1-15-2 Uchikanda, Chiyoda-ku, Tokyo", category: "Pubs, bar, izakaya" },
#   { name: "Bar Set Calm", address: "Kanda Shinyo Building B1F, 2-11-8 Uchikanda, Chiyoda-ku, Tokyo", category: "Bar" },
#   { name: "Beef Tongue x Private Room Meat Bar 29GABU Kanda Branch", address: "Watanabe Jyuken Building 2F, 3-12-5 Uchikanda, Chiyoda-ku, Tokyo", category: "Izakaya, seafood restaurant, bar" },
#   { name: "Jiyuukukan Kanda North Exit", address: "Sakurai Building 3F, 3-19-8 Uchikanda, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Sushi Restaurant Hishizen Otemachi Branch", address: "Katsubunsha Building 1F, 1-17-12 Uchikanda, Chiyoda-ku, Tokyo", category: "Sushi" },
#   { name: "Family Mart Kanda Station North Exit", address: "3-20-7 Uchikanda, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Hanataro Kanda Main Store", address: "Loire Kanda Building 2nd to 7th floors, 3-6-13 Uchikanda, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Folk Bar Showa", address: "Hachiya Building B1F, 3-22-10 Uchikanda, Chiyoda-ku, Tokyo", category: "Izakaya/Dining bar(other)" },
#   { name: "Tetesmanis", address: "Kohara Building 1F, 1-10-11 Uchikanda, Chiyoda-ku, Tokyo", category: "Cafes and coffee shops(other)" },
#   { name: "Manbo Plus Kanda store", address: "3-12-8 Uchikanda, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Shumonsen Kanda West Exit Station Store", address: "Watanabe Jyuken Building 2F, 3-12-5 Uchikanda, Chiyoda-ku, Tokyo", category: "Yakitori, chicken dishes" },
#   { name: "Hand beans and", address: "Otemachi Point Building 1F, 1-4-2 Uchikanda, Chiyoda-ku, Tokyo", category: "Bento" },
#   { name: "Bistro Cocone", address: "Tosei Hotel Cocone Kanda 1F, 3-2-10 Uchikanda, Chiyoda-ku, Tokyo", category: "Set meals/cafeteria" },
#   { name: "Family Mart Uchikanda 1-chome store", address: "Kanda Ocean Building, 1-15-2 Uchikanda, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Big Echo Kanda North Exit Main Store", address: "Central Hotel, 3-17-9 Uchikanda, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Kyushu Okinawa galore Nankurunaisa Kasumigaseki Iino Dining", address: "Iino Building B1F, 2-1-1 Uchisaiwaicho, Chiyoda-ku, Tokyo", category: "Okinawan cuisine, Izakaya, Motsunabe" },
#   { name: "Kagoshima Food Stall Fireball Boy Hibiya Branch", address: "Hibiya International Building B2F, 2-2-3 Uchisaiwaicho, Chiyoda-ku, Tokyo", category: "Izakaya" },
#   { name: "Scarecrow", address: "Hibiya International Building B1F, 2-2-3 Uchisaiwaicho, Chiyoda-ku, Tokyo", category: "Rice balls, bento" },
#   { name: "Cafe News", address: "1-1-7 Signature, Chiyoda-ku, Tokyo", category: "Set meals/cafeteria" },
#   { name: "Yatai DELi Fukoku Seimei Building Store", address: "Fukoku Seimei Building B2F, 2-2-2 Uchisaiwaicho, Chiyoda-ku, Tokyo", category: "Bento" },
#   { name: "Godiva Imperial Hotel Arcade Store", address: "B1F, 1-1-1 Uchiwaicho, Chiyoda-ku, Tokyo", category: "Chocolate" },
#   { name: "Tagirba", address: "Hibiya International Building B2F, 2-2-3 Uchisaiwaicho, Chiyoda-ku, Tokyo", category: "Izakaya" },
#   { name: "Stories of Italy", address: "Hibiya OKUROJI, 1-7-1 Uchisaiwaicho, Chiyoda-ku, Tokyo", category: "Cafe" },
#   { name: "Flower Room", address: "1-7-1 Uchisawaicho, Chiyoda-ku, Tokyo", category: "Ramen" },
#   { name: "Tokyo Mita Club", address: "Imperial Hotel Tokyo Main Building B1F, 1-1-1 Uchisaiwaicho, Chiyoda-ku, Tokyo", category: "Western food" },
#   { name: "Delicious fried chicken and izakaya food Miraizaka Hibiya Fukoku Seimei Building Branch", address: "Fukoku Seimei Building B2F, 2-2-2 Uchisaiwaicho, Chiyoda-ku, Tokyo", category: "Izakaya, Yakitori, Motsunabe" },
#   { name: "Mapo Specialist Chou Chen Lou", address: "Yu BAR, 2F Ura Corridor Street, 1-6-5 Uchisaiwaicho, Chiyoda-ku, Tokyo", category: "Chinese cuisine" },
#   { name: "Bakery", address: "JOB HUB SQUARE 1F, 2-6-2 Otemachi, Chiyoda-ku, Tokyo", category: "Bread, sandwiches" },
#   { name: "Natural Lawson Otemachi Financial City North Store", address: "Financial City North Tower B1F, 1-9-5 Otemachi, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Seven-Eleven Otemachi Conference Center Store", address: "Otemachi Conference Center B1F, 1-3-2 Otemachi, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Tully's Coffee Otemachi One", address: "Otemachi One B1F, 1-2-1 Otemachi, Chiyoda-ku, Tokyo", category: "Cafe" },
#   { name: "Coffee & Dining Bar Nana", address: "Otemachi Building B2F, 1-6-1 Otemachi, Chiyoda-ku, Tokyo", category: "Dining bar" },
#   { name: "Natural Lawson Otemachi Metropia Store", address: "1-6-1 Otemachi, Chiyoda-ku, Tokyo Chiyoda Line Otemachi Station", category: "Others" },
#   { name: "Tully's Coffee Marubeni Building", address: "Marubeni Head Office Building 1F, 1-4-2 Otemachi, Chiyoda-ku, Tokyo", category: "Coffee, Sandwiches, Pasta" },
#   { name: "Rough Orange", address: "Tokyo Sankei Building Neo Yatai Village, 1-7-2 Otemachi, Chiyoda-ku, Tokyo", category: "Bento" },
#   { name: "Seven-Eleven Otemachi Place", address: "Otemachi Place 28F, 2-1 Otemachi, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Saladice Otemachi Park Building", address: "Otemachi Park Building, 1-1-1 Otemachi, Chiyoda-ku, Tokyo", category: "Vegetable dishes, delicatessen" },
#   { name: "Yoshinoya", address: "1-9-5 Otemachi, Chiyoda-ku, Tokyo", category: "Beef bowl" },
#   { name: "Lawson Ote Center Building Store", address: "1-1-3 Otemachi, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Family Mart!! Otemon Tower Store", address: "Otemon Tower Eneos Building, 1-1-2 Otemachi, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "MY SYOKUDO HALL&KITCHEN", address: "TOKYO TORCH terrace 3F, 2-6-4 Otemachi, Chiyoda-ku, Tokyo", category: "Cafes and coffee shops (other)" },
#   { name: "BAR OMOcafe", address: "Takeuchi Building 1F, 1-4-3 Kajicho, Chiyoda-ku, Tokyo", category: "Bar, dining bar, bar and alcohol (other)" },
#   { name: "WRAPPED CREPE HEELS JR Kanda store", address: "2-12 Kajicho, Chiyoda-ku, Tokyo JR Kanda Station North and East Exit ticket gates", category: "Crepe" },
#   { name: "BAR Welcome Back", address: "1-2-14 Kajicho, Chiyoda-ku, Tokyo 1F", category: "Bar" },
#   { name: "Private Japanese Bar Hagi Kanda", address: "Sakurai Building No. 2, 3F, 2-1-6 Kajicho, Chiyoda-ku, Tokyo", category: "Izakaya, Seafood, Poultry" },
#   { name: "Family Mart Kanda Station East Exit Store", address: "2-7-1 Kajicho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Yokohama Iekei Ramen Haruki Kanda Branch", address: "1-5-1 Kajicho, Chiyoda-ku, Tokyo", category: "Ramen" },
#   { name: "Lawson Kanda Station East Exit", address: "2-2-9 Kajicho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Pelican Moon Caffe Kasumigaseki Common Gate Branch", address: "1F, West Wing, Kasumigaseki Common Gate, 3-2-1 Kasumigaseki, Chiyoda-ku, Tokyo", category: "Cafe, dining bar, izakaya" },
#   { name: "Omusubi Gonbei Ministry of Agriculture, Forestry and Fisheries Store", address: "1-2-1 Kasumigaseki, Chiyoda-ku, Tokyo", category: "Onigiri" },
#   { name: "Wrapped Crepe Corot Kasumigaseki Metro Branch", address: "2-1-2 Kasumigaseki, Chiyoda-ku, Tokyo", category: "Crepe" },
#   { name: "Olympic Awajicho store", address: "Waterras Mall B1F, 2-105 Kanda Awajicho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Family Mart Water Tower Store", address: "2-3 Kanda Awajicho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Seven-Eleven Kanda Awajicho Waterras Store", address: "Water's Annex 3F, 2-105 Kanda Awajicho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "The B Ochanomizu", address: "The B Ochanomizu, 1-7-5 Kanda Awajicho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Connoisseur Ginji Jimbocho Surugadaishita Branch", address: "Matsushita Building 1F, 3-3-2 Kanda Ogawamachi, Chiyoda-ku, Tokyo", category: "Izakaya, Seafood, Creative Cuisine" },
#   { name: "Akiyama", address: "2-8 Kanda Ogawamachi, Chiyoda-ku, Tokyo", category: "Coffee shop" },
#   { name: "Italian bar Deranchi.", address: "Koike Building 1F, 2-6 Kanda Ogawamachi, Chiyoda-ku, Tokyo", category: "Italian" },
#   { name: "Karaoke Maneki Neko Kanda Ogawamachi Branch", address: "Jimbocho Building 3F & 4F, 3-3 Kanda Ogawamachi, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Sunshine", address: "Shoryukan Building 1F, 3-28-7 Kanda Ogawamachi, Chiyoda-ku, Tokyo", category: "Bar, bistro, izakaya" },
#   { name: "Ichigoichiwara Jimbocho store", address: "1F, 3-7-15 Kanda Ogawamachi, Chiyoda-ku, Tokyo", category: "Sweets (Other)" },
#   { name: "Family Mart Pharmacy Higuchi Awajicho Store", address: "1-1-16 Kanda Ogawamachi, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Takarajima 24 Kanda store", address: "TC 4th Building, 2F-8F, 3-2-3 Kanda Kajicho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "MagMell", address: "3F, 44 Kanda Konyacho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Yakiushi Akihabara, a restaurant serving carefully selected Japanese Black beef and premium yakiniku", address: "Chiyoda Terrace 8F E2, 1-21-1 Kanda Sakumacho, Chiyoda-ku, Tokyo", category: "Yakiniku, Hormone, Izakaya" },
#   { name: "Private Hot Pot Restaurant Satsuma Biyori Akihabara Branch", address: "Ohashi Building 3F, 1-16 Kanda Sakumacho, Chiyoda-ku, Tokyo", category: "Izakaya, Motsunabe, Yakitori" },
#   { name: "Meat Grape Shop", address: "Taiyo Building 1F, 3-38 Kanda Sakumacho, Chiyoda-ku, Tokyo", category: "Steak, Wine Bar, Izakaya" },
#   { name: "Yen Akihabara store", address: "Kawahaji Building 6F, 1-15 Kanda Sakumacho, Chiyoda-ku, Tokyo", category: "Izakaya, Shabu-shabu, Yakiniku" },
#   { name: "Sumihito Public Bar Akihabara Branch", address: "Sanshin Building 2F, 1-20 Kanda Sakumacho, Chiyoda-ku, Tokyo", category: "Bars and other drinks" },
#   { name: "First Cabin Akihabara", address: "3-38 Kanda Sakumacho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "YMCA Hotel", address: "2-5-5 Kanda Sarugakucho, Chiyoda-ku, Tokyo", category: "Inns and auberges (other)" },
#   { name: "Shunsai Washoku Wagaya Jimbocho Branch", address: "Kurosawa Building 3F, 1-4 Kanda Jinbocho, Chiyoda-ku, Tokyo", category: "Izakaya, Japanese cuisine (other), creative cuisine" },
#   { name: "Morihachi Tokyo store", address: "1-13-3 Kanda Jinbocho, Chiyoda-ku, Tokyo", category: "Japanese sweets" },
#   { name: "Bincho-tei, Kanda Jinbocho", address: "1-25-2 Kanda Jinbocho, Chiyoda-ku, Tokyo", category: "Yakitori, Izakaya, Bars and Alcohol (Other)" },
#   { name: "Senshu University Kanda Campus Cafeteria", address: "Senshu University Kanda Campus B2F, 3-8 Kanda Jinbocho, Chiyoda-ku, Tokyo", category: "Student cafeteria" },
#   { name: "Pine tree", address: "Yasuda Jinbocho Mansion 1F, 3-11-1 Kanda Jinbocho, Chiyoda-ku, Tokyo", category: "Japanese cuisine, cafe" },
#   { name: "Rice flour cafe Tida", address: "Kaitakusha Building 2F, 2-5-4 Kanda Jinbocho, Chiyoda-ku, Tokyo", category: "Cafe" },
#   { name: "Seven-Eleven Kanda Jinbocho 3-chome Store", address: "3-2-6 Kanda Jinbocho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Japanese-style private room, authentic charcoal grilled chicken, Tori Shigure Jimbocho branch", address: "2-12-3 Kanda Jinbocho, Chiyoda-ku, Tokyo", category: "Izakaya, poultry dishes, seafood dishes" },
#   { name: "Sawaguchi Shoten Tokyo Antique Bookstore", address: "Genkogo Building 1st and 2nd floors, 1-7-21 Kanda Jinbocho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Seven-Eleven Kanda Jinbocho 2-chome store", address: "1F Kanda Jinbocho 2-chome Building, 2-2 Kanda Jinbocho, Chiyoda-ku, Tokyo", category: "Others" },
#   { name: "Tommy's Pudding Factory Jimbocho Branch", address: "1-1-9 Kanda Jinbocho, Chiyoda-ku, Tokyo", category: "Western confectionery (other)"} ,
# ]

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


# map
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

puts "Seeded #{User.count} users, #{Restaurant.count} restaurants, and #{Recommendation.count} recommendations."
