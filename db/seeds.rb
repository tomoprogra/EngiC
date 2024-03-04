# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

20.times do |n|
  User.create!(
    email: "user#{n}_#{Time.now.to_i}@example.com",
    password: "password",
    password_confirmation: "password",
    uid: "#{n}_#{Time.now.to_i}",
    provider: "twitter",
    username: "user_#{n}_#{Time.now.to_i}", # ユーザーネームにも時刻を追加
  )
end
