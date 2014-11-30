require "rails_helper"

describe ReminderCreator do
  context "when valid" do
    it "sends a confirmation email and tracks an event" do
      reminder_form = double("reminder_form")
      reminder = double(:reminder)
      user = double("user")
      reminder_factory = double("reminder_factory")
      analytics_factory = double("analytics_factory")
      analytics = double("analytics")
      mailer = double("mailer")
      email = double("email")
      allow(user).to receive(:reminders).and_return(reminder_factory)
      allow(reminder_form).to receive(:save).and_return(true)
      allow(reminder_form).to receive(:reminder).and_return(reminder)
      allow(mailer).to receive(:reminder_confirmation).and_return(email)
      allow(email).to receive(:deliver)
      allow(analytics_factory).to receive(:new).and_return(analytics)
      allow(analytics).to receive(:track_add_reminder)
      creator = ReminderCreator.new(
        reminder_form: reminder_form,
        user: user,
        analytics_factory: analytics_factory,
        mailer: mailer,
      )

      creator.call

      expect(reminder_form).to have_received(:save).
        with(reminder_factory: reminder_factory)
      expect(mailer).to have_received(:reminder_confirmation).with(reminder)
      expect(email).to have_received(:deliver)
      expect(analytics_factory).to have_received(:new).with(user)
      expect(analytics).to have_received(:track_add_reminder)
    end
  end

  context "when invalid" do
    it "sends an error email and doesn't track events" do
      reminder_form = double("reminder_form")
      user = double("user")
      reminder_factory = double("reminder_factory")
      analytics_factory = double("analytics_factory")
      mailer = double("mailer")
      email = double("email")
      allow(user).to receive(:reminders).and_return(reminder_factory)
      allow(reminder_form).to receive(:save).and_return(false)
      allow(mailer).to receive(:reminder_error).and_return(email)
      allow(email).to receive(:deliver)
      allow(analytics_factory).to receive(:new)
      creator = ReminderCreator.new(
        reminder_form: reminder_form,
        user: user,
        analytics_factory: analytics_factory,
        mailer: mailer,
      )

      creator.call

      expect(reminder_form).to have_received(:save).
        with(reminder_factory: reminder_factory)
      expect(mailer).to have_received(:reminder_error).with(user, reminder_form)
      expect(email).to have_received(:deliver)
      expect(analytics_factory).not_to have_received(:new)
    end
  end
end
