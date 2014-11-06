class Mailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_SENDER")

  def reminder(reminder)
    @reminder = reminder
    mail to: @reminder.email, subject: @reminder.title
  end
end
