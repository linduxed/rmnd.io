require "rails_helper"

feature "Editing reminders" do
  scenario "by clicking on their names and then submitting the changes" do
    travel_to Time.current do
      user = create(:user)
      create(
        :reminder,
        title: "Buy more milk",
        due_at: 2.days.from_now,
        repeat_frequency: nil,
        user: user,
      )

      visit reminders_path(as: user)
      click_link "Buy more milk"
      fill_in field("reminder.title"), with: "Don't buy milk"
      fill_in field("reminder.due_at"), with: 1.day.from_now
      select repeat_frequency("daily"), from: field("reminder.repeat_frequency")
      click_button button("reminder.update")

      expect(page).to have_content t("flashes.reminder_updated")
      expect(page).not_to have_content "Buy more milk"
      expect(page).to have_content "Don't buy milk"
      expect(page).to have_content l(1.day.from_now, format: :long)
      expect(page).to have_content t(
        "reminders.reminder.repeats",
        frequency: "daily",
      )
      expect(analytics).to have_tracked("Edited reminder").for_user(user)
      expect(analytics).to have_identified(user)
    end
  end

  scenario "trying to set the due date in the past" do
    travel_to Time.current do
      user = create(:user)
      reminder = create(:reminder, title: "Buy more milk", user: user)

      visit edit_reminder_path(reminder, as: user)
      fill_in field("reminder.due_at"), with: 10.minutes.ago
      click_button button("reminder.update")

      expect(page).not_to have_content t("flashes.reminder_updated")
      expect(page).not_to have_content l(10.minutes.ago, format: :long)
      expect(analytics).not_to have_tracked("Edited reminder").for_user(user)
      expect(analytics).not_to have_identified(user)
    end
  end

  scenario "trying to edit a sent reminder" do
    user = create(:user)
    sent_reminder = create(:reminder, :sent, title: "Buy more milk", user: user)

    visit reminders_path(as: user)

    expect(page).not_to have_link("Buy more milk")
    expect {
      visit edit_reminder_path(sent_reminder, as: user)
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
