class Mailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_SENDER")

  def reminder(reminder)
    @reminder = reminder
    mail \
      to: @reminder.email,
      subject: t("mailer.reminder.subject", title: @reminder.title)
  end

  def email_confirmation(user)
    @user = user
    mail to: @user.email, subject: t("mailer.email_confirmation.subject")
  end

  def reminder_confirmation(reminder)
    @reminder = reminder
    mail \
     to: @reminder.email,
     subject: t("mailer.reminder_confirmation.subject", title: @reminder.title)
  end

  def reminder_error(user, reminder_form)
    @reminder_form = reminder_form
    mail \
     to: user.email,
     subject: t("mailer.reminder_error.subject", title: @reminder_form.title)
  end
end
