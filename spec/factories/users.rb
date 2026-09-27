FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    nickname { "てす山　太郎" }
    password { "password" }
    password_confirmation { "password" }
  end
end