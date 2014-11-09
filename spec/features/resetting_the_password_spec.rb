require "rails_helper"

feature "Resetting the password" do
  scenario "by navigating to the page" do
    visit sign_in_path
    click_link t("sessions.new.forgot_password")

    expect(current_path).to eq new_password_path
  end

  scenario "with a valid email" do
    user = create(:user, email: "user@example.com")

    visit new_password_path
    fill_in field("password.email"), with: "user@example.com"
    click_button button("password.submit")

    expect(page).to have_content t("passwords.create.description")
    user.reload
    expect(user.confirmation_token).to be_present
    expect(emails.count).to eq(1)
    email = emails.last
    expect(email.to).to eq ["user@example.com"]
    expect(email.subject).to match /password/i
    expect(email.body).to match /#{user.email_confirmation_token}/
  end

  scenario "with an unknown email" do
    visit new_password_path
    fill_in field("password.email"), with: "unknown@example.com"
    click_button button("password.submit")

    expect(page).to have_content t("passwords.create.description")
    expect(ActionMailer::Base.deliveries).to be_empty
  end
end
