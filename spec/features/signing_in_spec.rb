require "rails_helper"

feature "Signing in" do
  scenario "with valid email and password" do
    create(:user, email: "user@example.com", password: "password")

    visit sign_in_path
    fill_in "session_email", with: "user@example.com"
    fill_in "session_password", with: "password"
    click_button t("helpers.submit.session.submit")

    expect(page).to have_button t("layouts.application.sign_out")
  end

  scenario "with valid mixed-case email and password " do
    create(:user, email: "user@example.com", password: "password")

    visit sign_in_path
    fill_in "session_email", with: "User@Example.com"
    fill_in "session_password", with: "password"
    click_button t("helpers.submit.session.submit")

    expect(page).to have_button t("layouts.application.sign_out")
  end

  scenario "with invalid password" do
    create(:user, email: "user@example.com", password: "right")

    visit sign_in_path
    fill_in "session_email", with: "user@example.com"
    fill_in "session_password", with: "wrong"
    click_button t("helpers.submit.session.submit")

    expect(page).to have_content t(
      "flashes.failure_after_create",
      sign_up_path: sign_up_path,
    )
    expect(page).not_to have_button t("layouts.application.sign_out")
  end

  scenario "with invalid email" do
    visit sign_in_path
    fill_in "session_email", with: "unknown@example.com"
    fill_in "session_password", with: "password"
    click_button t("helpers.submit.session.submit")

    expect(page).to have_content t(
      "flashes.failure_after_create",
      sign_up_path: sign_up_path,
    )
    expect(page).not_to have_button t("layouts.application.sign_out")
  end
end
