require "rails_helper"

feature "Signing up" do
  scenario "by navigating to the page" do
    visit sign_in_path
    click_link t("sessions.form.sign_up")

    expect(current_path).to eq sign_up_path
  end

  scenario "with a valid email and password" do
    visit sign_up_path
    fill_in field("user.email"), with: "user@example.com"
    fill_in field("user.password"), with: "password"
    click_button button("user.create")

    expect(page).to have_content t("flashes.signed_up")
    expect(page).to have_button t("application.navigation.sign_out")
    user = User.last
    expect(user.email_confirmation_token).to be_present
    expect(emails.count).to eq(1)
    email = emails.last
    expect(email.to).to eq ["user@example.com"]
    expect(email.subject).to eq t("mailer.email_confirmation.subject")
    expect(email.body).to include user_email_confirmation_url(
      user_id: user.id,
      token: user.email_confirmation_token,
    )
    expect(analytics).to have_tracked("Signed up").for_user(user)
    expect(analytics).to have_identified(user)
  end

  scenario "with an invalid email" do
    visit sign_up_path
    fill_in field("user.email"), with: "invalid email"
    fill_in field("user.password"), with: "password"
    click_button button("user.create")

    expect(page).not_to have_button t("application.navigation.sign_out")
  end

  scenario "with a blank password" do
    visit sign_up_path
    fill_in field("user.email"), with: "user@example.com"
    fill_in field("user.password"), with: ""
    click_button button("user.create")

    expect(page).not_to have_button t("application.navigation.sign_out")
  end

  scenario "from the home page" do
    visit root_path
    fill_in field("user.email"), with: "user@example.com"
    fill_in field("user.password"), with: "password"
    click_button button("user.create")

    expect(page).to have_button t("application.navigation.sign_out")
  end

  scenario "and setting a time zone" do
    travel_to Time.current.change(usec: 0) do
      visit sign_up_path
      fill_in field("user.email"), with: "user@example.com"
      fill_in field("user.password"), with: "password"
      select "Stockholm", from: field("user.time_zone")
      click_button button("user.create")
      visit reminders_path
      fill_in field("reminder.title"), with: "Buy milk"
      fill_in field("reminder.due_at"), with: 10.minutes.from_now
      click_button button("reminder.create")

      expect(page).to have_content l(
        Time.use_zone("Stockholm") { 10.minutes.from_now },
        format: :long,
      )
      reminder = Reminder.last
      expect(reminder.due_at).to eq 10.minutes.from_now
    end
  end
end
