require "rails_helper"

feature "Signing up" do
  scenario "by navigating to the page" do
    visit sign_in_path
    click_link t("sessions.form.sign_up")

    expect(current_path).to eq sign_up_path
  end

  scenario "with valid email and password" do
    visit sign_up_path
    fill_in "user_email", with: "user@example.com"
    fill_in "user_password", with: "password"
    click_button t("helpers.submit.user.create")

    expect(page).to have_button t("layouts.application.sign_out")
  end

  scenario "with invalid email" do
    visit sign_up_path
    fill_in "user_email", with: "invalid email"
    fill_in "user_password", with: "password"
    click_button t("helpers.submit.user.create")

    expect(page).not_to have_button t("layouts.application.sign_out")
  end

  scenario "with blank password" do
    visit sign_up_path
    fill_in "user_email", with: "user@example.com"
    fill_in "user_password", with: ""
    click_button t("helpers.submit.user.create")

    expect(page).not_to have_button t("layouts.application.sign_out")
  end
end
