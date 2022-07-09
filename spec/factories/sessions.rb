FactoryBot.define do
  factory :session do
    user { create(:user) }
    refresh_token { "MyString" }
    ip { Faker::Internet.ip_v4_address }
    user_agent { "MyString" }
    trait :logged_out do
      logged_out { true }
    end
  end
end
