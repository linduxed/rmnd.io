FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password"

    trait :confirmed_email do
      email_confirmed_at { Time.current }
    end

    trait :unconfirmed_email do
      email_confirmed_at nil
    end
  end

  factory :reminder do
    user
    sequence(:title) { |n| "Reminder #{n}" }
    due_at { 1.day.from_now }

    trait :cancelled do
      cancelled_at { Time.current }
    end

    trait :uncancelled do
      cancelled_at nil
    end
  end
end
