class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    in_user_time_zone do
      reminder_creator.call
    end
  end

  private

  attr_reader :email

  delegate :subject, to: :email

  def in_user_time_zone(&block)
    Time.use_zone(user.time_zone, &block)
  end

  def reminder_creator
    ReminderCreator.new(
      reminder_form: reminder_form,
      user: user,
      analytics_factory: analytics_factory,
      mailer: Mailer,
    )
  end

  def reminder_form
    ReminderForm.new(due_date: token, title: subject)
  end

  def user
    @user ||= user_locator.call(email: from)
  end

  def user_locator
    UserLocator.new(
      user_factory: user_factory,
      not_found_strategy: not_found_strategy,
    )
  end

  def not_found_strategy
    SignUp.new(
      user_factory: user_factory,
      analytics_factory: analytics_factory,
    )
  end

  def user_factory
    User
  end

  def analytics_factory
    Analytics
  end

  def token
    email.to.first[:token]
  end

  def from
    email.from[:email]
  end
end
