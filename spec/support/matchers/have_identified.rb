RSpec::Matchers.define :have_identified do |user|
  match do |backend|
    @user = user
    @backend = backend
    @traits ||= {}

    backend.has_identified?(@user, @traits)
  end

  description do
    "identified user"
  end

  failure_message do |text|
    "expected identification of user '#{@user}' with traits #{@traits}, who "\
      "was not"
  end

  failure_message_when_negated do |text|
    "expected no identification of user '#{@user}' with traits #{@traits}, "\
      "who was"
  end

  chain(:with_traits) { |traits| @traits = traits }
end
