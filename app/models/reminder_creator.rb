class ReminderCreator
  def initialize(reminder_form:, user:, analytics_factory:, mailer:)
    @reminder_form = reminder_form
    @user = user
    @analytics_factory = analytics_factory
    @mailer = mailer
  end

  def call
    if save_reminder
      send_confirmation
      track_add_reminder
    else
      send_error
    end
  end

  private

  delegate :track_add_reminder, to: :analytics

  def save_reminder
    reminder_form.save(reminder_factory: user.reminders)
  end

  def send_confirmation
    mailer.reminder_confirmation(reminder_form.reminder).deliver
  end

  def analytics
    analytics_factory.new(user)
  end

  def send_error
    mailer.reminder_error(user, reminder_form).deliver
  end

  attr_reader :reminder_form, :user, :analytics_factory, :mailer
end
