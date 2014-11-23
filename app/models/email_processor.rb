class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    if user.present?
      Time.use_zone user.time_zone do
        if reminder_form.save(reminder_factory: user.reminders)
          Mailer.reminder_confirmation(reminder_form.reminder).deliver
          analytics.track_add_reminder
        else
          Mailer.reminder_error(user, reminder_form).deliver
        end
      end
    end
  end

  private

  attr_reader :email

  delegate :subject, to: :email

  def user
    @user ||= User.find_by(email: from)
  end

  def reminder_form
    @reminder_form ||= ReminderForm.new(email_form_params)
  end

  def email_form_params
    {
      due_date: token,
      title: subject,
    }
  end

  def token
    email.to.first[:token]
  end

  def from
    email.from[:email]
  end

  def analytics
    Analytics.new(user)
  end
end
