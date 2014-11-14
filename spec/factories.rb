FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password "password"
    time_zone "UTC"

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

    trait :sent do
      sent_at { Time.current }
    end

    trait :unsent do
      sent_at nil
    end

    trait :repeating do
      repeat_frequency :daily
    end
  end
end
