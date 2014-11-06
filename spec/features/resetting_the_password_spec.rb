require "rails_helper"

feature "Resetting the password" do
  scenario "by navigating to the page" do
    visit sign_in_path
    click_link t("sessions.form.forgot_password")

    expect(current_path).to eq new_password_path
  end

  scenario "with a valid email" do
    user = create(:user, email: "user@example.com")

    visit new_password_path
    fill_in "password_email", with: "user@example.com"
    click_button t("helpers.submit.password.submit")

    expect(page).to have_content t("passwords.create.description")
    user.reload
    expect(user.confirmation_token).to be_present
    expect(ActionMailer::Base.deliveries).not_to be_empty

    message = ActionMailer::Base.deliveries.any? do |email|
      email.to == ["user@example.com"] &&
        email.subject =~ /password/i &&
        email.body =~ /#{user.confirmation_token}/
    end

    expect(message).to be
  end

  scenario "with an unknown email" do
    visit new_password_path
    fill_in "password_email", with: "unknown@example.com"
    click_button t("helpers.submit.password.submit")

    expect(page).to have_content t("passwords.create.description")
    expect(ActionMailer::Base.deliveries).to be_empty
  end
end
