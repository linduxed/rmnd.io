require "rails_helper"

feature "Signing up" do
  scenario "by navigating to the page" do
    visit sign_in_path
    click_link t("sessions.form.sign_up")

    expect(current_path).to eq sign_up_path
  end

  scenario "with valid email and password" do
    visit sign_up_path
    fill_in field("user.email"), with: "user@example.com"
    fill_in field("user.password"), with: "password"
    click_button button("user.create")

    expect(page).to have_button t("application.navigation.sign_out")
  end

  scenario "with invalid email" do
    visit sign_up_path
    fill_in field("user.email"), with: "invalid email"
    fill_in field("user.password"), with: "password"
    click_button button("user.create")

    expect(page).not_to have_button t("application.navigation.sign_out")
  end

  scenario "with blank password" do
    visit sign_up_path
    fill_in field("user.email"), with: "user@example.com"
    fill_in field("user.password"), with: ""
    click_button button("user.create")

    expect(page).not_to have_button t("application.navigation.sign_out")
  end
end
