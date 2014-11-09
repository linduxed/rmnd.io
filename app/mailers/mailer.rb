class Mailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_SENDER")

  def reminder(reminder)
    @reminder = reminder
    mail to: @reminder.email, subject: @reminder.title
  end

  def email_confirmation(user)
    @user = user
    mail to: @user.email, subject: t("mailer.email_confirmation.subject")
  end
end
