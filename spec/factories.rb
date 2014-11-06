FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password"
  end

  factory :reminder do
    user
    sequence(:title) { |n| "Reminder #{n}" }
    due_at { 1.day.from_now }
  end
end
