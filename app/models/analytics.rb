class Analytics
  class_attribute :backend
  self.backend = AnalyticsRuby

  def initialize(user)
    @user = user
  end

  def track_sign_up
    identify
    track(user_id: user.id, event: "Signed up")
  end

  def track_sign_in
    identify
    track(user_id: user.id, event: "Signed in")
  end

  def track_sign_out
    identify
    track(user_id: user.id, event: "Signed out")
  end

  def track_add_reminder
    identify
    track(user_id: user.id, event: "Added reminder")
  end

  def track_edit_reminder
    identify
    track(user_id: user.id, event: "Edited reminder")
  end

  def track_cancel_reminder
    identify
    track(user_id: user.id, event: "Cancelled reminder")
  end

  private

  def identify
    backend.identify(identify_params)
  end

  attr_reader :user

  def identify_params
    {
      user_id: user.id,
      traits: user_traits
    }
  end

  def user_traits
    {
      email: user.email,
    }
  end

  def track(options)
    backend.track(options)
  end
end
