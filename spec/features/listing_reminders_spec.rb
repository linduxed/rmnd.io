require "rails_helper"

feature "Listing reminders" do
  scenario "when there are reminders" do
    user = create(:user)
    create(
      :reminder,
      title: "Take out the trash",
      due_at: 1.days.from_now,
      user: user,
      sent_at: nil,
    )
    create(
      :reminder,
      title: "Buy milk",
      due_at: 2.days.from_now,
      user: user,
      sent_at: nil,
    )
    sign_up = create(
      :reminder,
      title: "Sign up for rmnd.io",
      due_at: 1.day.ago,
      sent_at: 1.day.ago,
      user: user,
    )

    visit reminders_path(as: user)

    expect(page).not_to have_content t("reminders.index.no_reminders")
    expect(page).to have_content("Take out the trash")
    expect(page).to have_content("Buy milk")
    expect(page).to have_content("Sign up for rmnd.io")
    expect("Take out the trash").to appear_on_page_before("Buy milk")
    expect("Buy milk").to appear_on_page_before("Sign up for rmnd.io")
    within("##{dom_id(sign_up)}.sent") do
      expect(page).not_to have_button t("reminders.reminder.cancel")
    end
  end

  scenario "when there are no reminders" do
    visit reminders_path(as: create(:user))

    expect(page).to have_content t("reminders.index.no_reminders")
  end
end
