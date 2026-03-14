# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.find_or_initialize_by(email: "stugiiz17@gmail.com")
user.assign_attributes(password: "mascot17", role: "admin", deezer_id: "2224765", user_name: "Rob")
user.save!

user = User.find_or_initialize_by(email: "titouan.andritsos@gmail.com")
user.assign_attributes(password: "555666", role: "admin", deezer_id: "2937737684", user_name: "Tits")
user.save!

user = User.find_or_initialize_by(email: "andie")
user.assign_attributes(password: "555666", role: "admin", deezer_id: "6784840983", user_name: "Andie")
user.save!
