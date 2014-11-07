require "rails_helper"

feature "Adding reminders" do
  scenario "without descriptions" do
    visit reminders_path(as: create(:user))

    fill_in field("reminder.title"), with: "Buy milk"
    fill_in field("reminder.due_at"), with: "2014-11-06 22:34"
    click_button button("reminder.create")

    expect(page).to have_content "Buy milk"
    expect(page).to have_content l(Time.new(2014, 11, 6, 22, 34), format: :long)
  end

  scenario "with human due date" do
    travel_to Time.current do
      visit reminders_path(as: create(:user))

      fill_in field("reminder.title"), with: "Buy milk"
      fill_in field("reminder.due_at"), with: "tomorrow at 4"
      click_button button("reminder.create")

      expect(page).to have_content "Buy milk"
      expect(page).to have_content l(1.day.from_now.change(hour: 16), format: :long)
    end
  end

  scenario "with descriptions" do
    visit reminders_path(as: create(:user))

    fill_in field("reminder.title"), with: "Buy milk"
    fill_in field("reminder.due_at"), with: "2014-11-06 22:34"
    fill_in field("reminder.description"), with: "The good one."
    click_button button("reminder.create")

    expect(page).to have_content "Buy milk"
    expect(page).to have_content l(Time.new(2014, 11, 6, 22, 34), format: :long)
    expect(page).to have_content "The good one."
  end

  scenario "that are repeating" do
    visit reminders_path(as: create(:user))

    fill_in field("reminder.title"), with: "Buy milk"
    fill_in field("reminder.due_at"), with: "2014-11-06 22:34"
    select repeat_frequency("daily"), from: field("reminder.repeat_frequency")
    click_button button("reminder.create")

    expect(page).to have_content "Buy milk"
    expect(page).to have_content l(Time.new(2014, 11, 6, 22, 34), format: :long)
    expect(page).to have_content t(
      "reminders.reminder.repeats",
      frequency: "daily",
    )
  end

  scenario "that are invalid" do
    visit reminders_path(as: create(:user))

    click_button button("reminder.create")
  end

  def repeat_frequency(name)
    t(name, scope: "reminders.repeat_frequencies")
  end
end
