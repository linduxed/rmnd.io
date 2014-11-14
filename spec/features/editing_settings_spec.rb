require "rails_helper"

feature "Editing settings" do
  scenario "changing time zone" do
    user = create(:user, time_zone: "UTC")

    visit root_path(as: user)
    click_link t("application.navigation.settings")
    select "Stockholm", from: field("user.time_zone")
    click_button button("user.update")

    expect(page).to have_content t("flashes.settings_updated")
    expect(analytics).to have_tracked("Edited settings").for_user(user)
    expect(analytics).to have_identified(user)
  end
end
