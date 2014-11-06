class Mailer < ActionMailer::Base
  def reminder(reminder)
    @reminder = reminder
    mail to: reminder.email, subject: reminder.title
  end
end
