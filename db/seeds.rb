# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
names = [
  "佐藤 健", "鈴木 一郎", "高橋 翔太", "田中 太郎",
  "伊藤 花子", "渡辺 京子", "山本 悠斗", "中村 優子",
  "小林 大輔", "加藤 美咲", "吉田 裕也", "山田 理子",
  "佐々木 直人", "山口 真由", "松本 翼", "井上 陽水",
  "木村 拓哉", "林 健太郎", "清水 明美", "斉藤 真紀"
]

20.times do |n|
  User.create!(
    email: "user#{n}@example.com",
    password: "password",
    password_confirmation: "password",
    uid: "#{n}#{rand(1000..9999)}",
    provider: "twitter",
    username: "user_#{n}", # バリデーション要件を満たすユーザーネーム
    name: names[n], # 日本人の名前を割り当て
  )
end
