require "rails_helper"

feature "Adding reminders" do
  scenario "without descriptions" do
    visit reminders_path(as: create(:user))

    fill_in field("reminder.title"), with: "Buy milk"
    select_datetime(2014, 11, 6, 22, 34, from: field("reminder.due_at"))
    click_button button("reminder.create")

    expect(page).to have_content "Buy milk"
    expect(page).to have_content l(Time.new(2014, 11, 6, 22, 34), format: :long)
  end

  scenario "with descriptions" do
    visit reminders_path(as: create(:user))

    fill_in field("reminder.title"), with: "Buy milk"
    select_datetime(2014, 11, 6, 22, 34, from: field("reminder.due_at"))
    fill_in field("reminder.description"), with: "The good one."
    click_button button("reminder.create")

    expect(page).to have_content "Buy milk"
    expect(page).to have_content l(Time.new(2014, 11, 6, 22, 34), format: :long)
    expect(page).to have_content "The good one."
  end

  scenario "that are repeating" do
    visit reminders_path(as: create(:user))

    fill_in field("reminder.title"), with: "Buy milk"
    select_datetime(2014, 11, 6, 22, 34, from: field("reminder.due_at"))
    select repeat_frequency("daily"), from: field("reminder.repeat_frequency")
    click_button button("reminder.create")

    expect(page).to have_content "Buy milk"
    expect(page).to have_content l(Time.new(2014, 11, 6, 22, 34), format: :long)
    expect(page).to have_content t(
      "reminders.reminder.repeats",
      frequency: "daily",
    )
  end

  def repeat_frequency(name)
    t(name, scope: "reminders.repeat_frequencies")
  end
end
