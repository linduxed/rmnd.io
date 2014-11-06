require "rails_helper"

feature "Sending reminders" do
  scenario "by running the rake task" do
    travel_to Time.current do
      alice = create(:user, email: "alice@example.com")
      bob = create(:user, email: "bob@example.com")
      create(
        :reminder,
        user: alice,
        title: "Already sent",
        due_at: 10.minutes.ago,
        sent_at: 1.minute.ago,
      )
      create(
        :reminder,
        user: alice,
        title: "Go to the gym",
        due_at: 1.minute.ago,
        sent_at: nil,
      )
      create(
        :reminder,
        user: bob,
        title: "Buy milk",
        description: "The good one.",
        due_at: 1.minute.ago,
        sent_at: 10.minutes.ago,
      )

      run_rake_task("reminders:send")

      expect(Reminder.due.count).to eq 0
      expect(ActionMailer::Base.deliveries.count).to eq 2

      alices_reminder_email = ActionMailer::Base.deliveries.find do |email|
        email.to == ["alice@example.com"] &&
          email.subject =~ /Go to the gym/i
      end

      bobs_reminder_email = ActionMailer::Base.deliveries.find do |email|
        email.to == ["bob@example.com"] &&
          email.subject =~ /Buy milk/i &&
          email.body =~ /The good one./i
      end

      expect(alices_reminder_email).to be
      expect(bobs_reminder_email).to be
    end
  end
end
