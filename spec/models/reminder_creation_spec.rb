require "rails_helper"

describe ReminderCreation do
  describe "#call" do
    it "creates a reminder form with a user" do
      ReminderCreation.new(
        email: "user@example.com",
        due_date: "tomorrowat2pm",
        title: "Buy milk.",
      ).call

      expect(user_factory).to have_received(:with_email).
        with("user@example.com")
      expect(reminder_form_factory).to have_received(:new).with(
        user: user,
        due_date: "tomorrowat2pm",
        title: "Buy milk.",
      )
      expect(reminder_form).to receieve(:save)
    end
  end
end
