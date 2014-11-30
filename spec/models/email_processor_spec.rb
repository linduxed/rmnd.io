require "rails_helper"

describe EmailProcessor do
  describe "#process" do
    it "creates a reminder" do
      email = create(
        "email",
        from: { email: "user@example.com" },
        to: [{ token: "tomorrowat2pm" }],
        subject: "Buy milk.",
      )
      reminder_form = double("reminder_form")
      sign_up = double("sign_up")
      user_locator = double("user_locator")
      user = double("user")
      reminder_creator = double("reminder_creator")
      allow(ReminderForm).to receive(:new).and_return(reminder_form)
      allow(SignUp).to receive(:new).and_return(sign_up)
      allow(UserLocator).to receive(:new).and_return(user_locator)
      allow(user_locator).to receive(:call).and_return(user)
      allow(user).to receive(:time_zone).and_return("Europe/Stockholm")
      allow(Time).to receive(:use_zone).and_yield
      allow(ReminderCreator).to receive(:new).and_return(reminder_creator)
      allow(reminder_creator).to receive(:call)

      EmailProcessor.new(email).process

      expect(ReminderForm).to have_received(:new).with(
        due_date: "tomorrowat2pm",
        title: "Buy milk.",
      )
      expect(SignUp).to have_received(:new).with(
        user_factory: User,
        analytics_factory: Analytics,
      )
      expect(UserLocator).to have_received(:new).with(
        user_factory: User,
        not_found_strategy: sign_up,
      )
      expect(user_locator).to have_received(:call).with(
        email: "user@example.com",
      )
      expect(Time).to have_received(:use_zone).with("Europe/Stockholm")
      expect(ReminderCreator).to have_received(:new).with(
        reminder_form: reminder_form,
        user: user,
        analytics_factory: Analytics,
        mailer: Mailer,
      )
      expect(reminder_creator).to have_received(:call)
    end
  end
end
