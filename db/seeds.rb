# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.find_or_create_by!(email: "stugiiz17@gmail.com") do |u|
  u.password = "mascot17"
  u.role = "admin"
  u.deezer_id = "2224765"
  u.user_name = "Rob"
end
User.find_or_create_by!(email: "titouan.andritsos@gmail.com") do |u|
  u.password = "555666"
  u.role = "admin"
  u.deezer_id = "2937737684"
  u.user_name = "Tits"
end
User.find_or_create_by!(email: "andie") do |u|
  u.password = "555666"
  u.role = "admin"
  u.deezer_id = "6784840983"
  u.user_name = "Andie"
end
