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

  factory :email, class: OpenStruct do
    to [
      {
        full: "to_user@example.com",
        email: "to_user@example.com",
        token: "to_user",
        host: "example.com",
        name: nil
      },
    ]
    from(
      token: "from_user",
      host: "example.com",
      email: "from_email@example.com",
      full: "From User <from_user@example.com",
      name: "From User",
    )
    subject "Email subject"
    body "Email body"
    attachments { [] }
  end
end
