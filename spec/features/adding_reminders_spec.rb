require "rails_helper"

feature "Adding reminders" do
  scenario "with a normal due date" do
    user = create(:user)

    visit reminders_path(as: user)

    fill_in field("reminder.title"), with: "Buy milk"
    fill_in field("reminder.due_at"), with: "2014-11-06 22:34"
    click_button button("reminder.create")

    expect(page).to have_content t("flashes.reminder_added")
    expect(page).to have_content "Buy milk"
    expect(page).to have_content l(Time.new(2014, 11, 6, 22, 34), format: :long)
    expect(analytics).to have_tracked("Added reminder").for_user(user)
    expect(analytics).to have_identified(user)
  end

  scenario "with a human due date" do
    travel_to Time.current do
      visit reminders_path(as: create(:user))

      fill_in field("reminder.title"), with: "Buy milk"
      fill_in field("reminder.due_at"), with: "tomorrow at 4"
      click_button button("reminder.create")

    expect(page).to have_content t("flashes.reminder_added")
      expect(page).to have_content "Buy milk"
      expect(page).to have_content l(1.day.from_now.change(hour: 16), format: :long)
    end
  end

  scenario "that are repeating" do
    visit reminders_path(as: create(:user))

    fill_in field("reminder.title"), with: "Buy milk"
    fill_in field("reminder.due_at"), with: "2014-11-06 22:34"
    select repeat_frequency("daily"), from: field("reminder.repeat_frequency")
    click_button button("reminder.create")

    expect(page).to have_content t("flashes.reminder_added")
    expect(page).to have_content "Buy milk"
    expect(page).to have_content l(Time.new(2014, 11, 6, 22, 34), format: :long)
    expect(page).to have_content t(
      "reminders.reminder.repeats",
      frequency: "daily",
    )
  end

  scenario "that are invalid" do
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

    click_button button("reminder.create")

    expect(page).not_to have_content t("flashes.reminder_added")
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

  scenario "with an unparseable due date" do
    visit reminders_path(as: create(:user))

    fill_in field("reminder.title"), with: "Buy milk"
    fill_in field("reminder.due_at"), with: "not a date"
    click_button button("reminder.create")

    expect(page).not_to have_content t("flashes.reminder_added")
    expect(find_field(field("reminder.due_at")).value).to be_blank
  end

  scenario "with an unconfirmed email" do
    visit reminders_path(as: create(:user, :unconfirmed_email))

    fill_in field("reminder.title"), with: "Buy milk"
    fill_in field("reminder.due_at"), with: "2014-11-06 22:34"
    click_button button("reminder.create")

    expect(page).to have_content t("flashes.reminder_added")
    expect(page).to have_content t("flashes.email_unconfirmed")
  end
end
