namespace :reminders do
  desc "Send out due reminders"
  task send: :environment do
    Reminder.due.find_each do |reminder|
      Mailer.reminder(reminder).deliver
      reminder.mark_as_sent!
    end
  end
end
