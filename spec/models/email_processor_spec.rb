require "rails_helper"

describe EmailProcessor do
  describe "#process" do
    context "when the email comes from a registered user" do
      it "creates a reminder" do
        travel_to Time.current do
          user = create(:user, email: "user@example.com")
          reminder_form = double(:reminder_form)
          reminder = build_stubbed(:reminder, user: user)
          allow(ReminderForm).to receive(:new).and_return(reminder_form)
          allow(reminder_form).to receive(:save).and_return(true)
          allow(reminder_form).to receive(:reminder).and_return(reminder)
          email = create(
            :email,
            from: { email: "user@example.com" },
            to: [{ token: 10.minutes.from_now.iso8601 }],
            subject: "Buy milk",
          )

          EmailProcessor.new(email).process

          expect(ReminderForm).to have_received(:new).with(
            due_date: 10.minutes.from_now.iso8601,
            title: "Buy milk",
          )
          expect(reminder_form).to have_received(:save).
            with(reminder_factory: user.reminders)
        end
      end
    end

    context "when the email comes from a stranger" do
      it "drops it" do
        allow(ReminderForm).to receive(:new)
        email = create(:email, from: { email: "stranger@example.com" })

        EmailProcessor.new(email).process

        expect(ReminderForm).not_to have_received(:new)
      end
    end
  end
end
