require "rails_helper"

feature "Cancelling reminders" do
  scenario "by clicking on the cancel button" do
    user = create(:user)
    buy_milk = create(:reminder, title: "Buy milk", user: user)
    take_out_the_trash = create(
      :reminder,
      title: "Take out the trash",
      user: user,
    )

    visit reminders_path(as: user)

    within("##{dom_id(buy_milk)}") do
      click_button t("reminders.reminder.cancel")
    end

    expect(page).to have_content t("flashes.reminder_cancelled")
    expect(page).not_to have_content("Buy milk")
    expect(analytics).to have_tracked("Cancelled reminder").for_user(user)
    expect(analytics).to have_identified(user)
  end
end
