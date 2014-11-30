class SignUp
  def initialize(user_factory:, analytics_factory:)
    @user_factory = user_factory
    @analytics_factory = analytics_factory
  end

  def call(email:)
    user_factory.create!(email: email).tap do |user|
      analytics_factory.new(user).track_sign_up
    end
  end

  private

  attr_reader :user_factory, :analytics_factory
end
