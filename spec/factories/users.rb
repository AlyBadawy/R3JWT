FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.username(specifier: 5..10) }
    password { "passW0rd" }
    trait :admin do
      admin { true }
    end
  end
end
