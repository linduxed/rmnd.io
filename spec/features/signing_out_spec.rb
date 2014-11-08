require "rails_helper"

feature "Signing out" do
  scenario "signed in user signs out" do
    user = create(:user)

    visit root_path(as: user)
    click_button t("application.navigation.sign_out")

    expect(page).not_to have_button t("application.navigation.sign_out")
  end
end
