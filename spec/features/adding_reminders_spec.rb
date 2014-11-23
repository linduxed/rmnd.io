require "rails_helper"

feature "Adding reminders" do
  scenario "with a normal due date" do
    travel_to Time.current do
      user = create(:user)

      visit reminders_path(as: user)

      fill_in field("reminder_form.title"), with: "Buy milk"
      fill_in field("reminder_form.due_date"), with: 10.minutes.from_now.iso8601
      click_button button("reminder_form.create")

      expect(page).to have_content t("flashes.reminder_added")
      expect(page).to have_content "Buy milk"
      expect(page).to have_content l(10.minutes.from_now, format: :long)
      expect(analytics).to have_tracked("Added reminder").for_user(user)
      expect(analytics).to have_identified(user)
    end
  end

  scenario "with a human due date" do
    travel_to Time.zone.local(2014, 11, 20, 12, 0, 0) do
      visit reminders_path(as: create(:user))

      fill_in field("reminder_form.title"), with: "Buy milk"
      fill_in field("reminder_form.due_date"), with: "tomorrow at 4pm"
      click_button button("reminder_form.create")

      expect(page).to have_content t("flashes.reminder_added")
      expect(page).to have_content "Buy milk"
      expect(page).to have_content l(
        Time.zone.local(2014, 11, 21, 16, 0, 0),
        format: :long,
      )
    end
  end

  scenario "that are repeating" do
    travel_to Time.current do
      visit reminders_path(as: create(:user))

      fill_in field("reminder_form.title"), with: "Buy milk"
      fill_in field("reminder_form.due_date"), with: 10.minutes.from_now.iso8601
      select repeat_frequency("daily"),
             from: field("reminder_form.repeat_frequency")
      click_button button("reminder_form.create")

      expect(page).to have_content t("flashes.reminder_added")
      expect(page).to have_content "Buy milk"
      expect(page).to have_content l(10.minutes.from_now, format: :long)
      expect(page).to have_content t(
        "reminders.reminder.repeats",
        frequency: "daily",
      )
    end
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

    click_button button("reminder_form.create")

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

    fill_in field("reminder_form.title"), with: "Buy milk"
    fill_in field("reminder_form.due_date"), with: "not a date"
    click_button button("reminder_form.create")

    expect(page).not_to have_content t("flashes.reminder_added")
    expect(page).to have_content t("errors.messages.invalid")
  end

  scenario "with an unconfirmed email" do
    travel_to Time.current do
      visit reminders_path(as: create(:user, :unconfirmed_email))

      fill_in field("reminder_form.title"), with: "Buy milk"
      fill_in field("reminder_form.due_date"), with: 10.minutes.from_now.iso8601
      click_button button("reminder_form.create")

      expect(page).to have_content t("flashes.reminder_added")
      expect(page).to have_content t("flashes.email_unconfirmed")
    end
  end

  scenario "with a due date in the past" do
    visit reminders_path(as: create(:user))

    fill_in field("reminder_form.title"), with: "Buy milk"
    fill_in field("reminder_form.due_date"), with: 10.minutes.ago.iso8601
    click_button button("reminder_form.create")

    expect(page).not_to have_content t("flashes.reminder_added")
    expect(page).to have_content t("errors.messages.past")
  end

  scenario "via email" do
    travel_to Time.new(2014, 11, 23, 21, 20, 0, 0) do
      user = create(
        :user,
        email: "user@example.com",
        time_zone: "Pacific Time (US & Canada)",
      )

      simulate_email_from(
        user,
        to: "tomorrow@rmnd.io",
        subject: "Buy milk",
      )

      email = emails.last
      expect(email.to).to eq ["user@example.com"]
      expect(email.subject).to eq t(
        "mailer.reminder_confirmation.subject",
        title: "Buy milk",
      )
      expect(email.body).to include t(
        "mailer.reminder_confirmation.what",
        title: "Buy milk",
      )
      expect(email.body).to include t(
        "mailer.reminder_confirmation.when",
        due_at: l(
          Time.current.tomorrow.change(hour: 12),
          format: :long,
        ),
      )
      expect(emails.count).to eq(1)
      expect(analytics).to have_tracked("Added reminder").for_user(user)
      expect(analytics).to have_identified(user)

      visit reminders_path(as: user)

      expect(page).to have_content "Buy milk"
      expect(page).to have_content l(
        Time.current.tomorrow.change(hour: 12),
        format: :long,
      )
    end
  end

  scenario "invalid via email" do
    user = create(
      :user,
      email: "user@example.com",
    )

    simulate_email_from(
      user,
      to: "notadate@rmnd.io",
      subject: "Buy milk",
    )

    email = emails.last
    expect(email.to).to eq ["user@example.com"]
    expect(email.subject).to eq t(
      "mailer.reminder_error.subject",
      title: "Buy milk",
    )
    expect(email.body).to include t(
      "mailer.reminder_error.what",
      title: "Buy milk",
    )
    expect(email.body).to include t(
      "mailer.reminder_error.when",
      due_date: "notadate",
    )
    expect(email.body).to include t(
      "errors.format",
      attribute: field("reminder_form.due_date"),
      message: t("errors.messages.invalid"),
    )
    expect(emails.count).to eq(1)
    expect(analytics).not_to have_tracked("Added reminder").for_user(user)
    expect(analytics).not_to have_identified(user)

    visit reminders_path(as: user)

    expect(page).not_to have_content "Buy milk"
  end

  def simulate_email_from(user, to:, subject:)
    params = {
      mandrill_events: [
        {
          event: "inbound",
          msg: {
            from_email: user.email,
            to: [[to]],
            subject: subject,
          }
        }
      ].to_json
    }
    Capybara.current_session.driver.post emails_path, params
  end
end
