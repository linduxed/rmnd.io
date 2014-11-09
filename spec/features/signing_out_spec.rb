require "rails_helper"

feature "Signing out" do
  scenario "signed in user signs out" do
    user = create(:user)

    visit root_path(as: user)
    click_button t("application.navigation.sign_out")

    expect(page).not_to have_button t("application.navigation.sign_out")
    expect(analytics).to have_tracked("Signed out").for_user(user)
    expect(analytics).to have_identified(user)
  end
end
