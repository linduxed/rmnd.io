class UserLocator
  def initialize(user_factory:, not_found_strategy:)
    @user_factory = user_factory
    @not_found_strategy = not_found_strategy
  end

  def call(email:)
    user_factory.find_by(email: email) || not_found_strategy.call(email: email)
  end

  private

  attr_reader :user_factory, :not_found_strategy
end
