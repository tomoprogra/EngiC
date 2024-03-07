FactoryBot.define do
  factory :user do
    sequence(:username) {|n| "user_#{n}" }
    password { "1234567890" }
    sequence(:email) {|n| "tester#{n}@example.com" }
  end
end
