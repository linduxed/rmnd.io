namespace :reminders do
  desc "Send out due reminders"
  task send: :environment do
    Reminder.includes(:user).due.find_each do |reminder|
      if reminder.email_confirmed?
        Mailer.reminder(reminder).deliver
      end
      reminder.mark_as_sent!
    end
  end
end
