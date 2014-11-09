require "rails_helper"

feature "Listing reminders" do
  scenario "when there are reminders" do
    user = create(:user)
    buy_milk = create(:reminder, title: "Buy milk", user: user)
    take_out_the_trash = create(
      :reminder,
      title: "Take out the trash",
      user: user,
    )

    visit reminders_path(as: user)

    expect(page).not_to have_content t("reminders.index.no_reminders")
    expect(page).to have_content("Buy milk")
    expect(page).to have_content("Take out the trash")
  end

  scenario "when there are no reminders" do
    visit reminders_path(as: create(:user))

    expect(page).to have_content t("reminders.index.no_reminders")
  end
end
