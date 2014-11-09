RSpec::Matchers.define :have_tracked do |event_name|
  match do |backend|
    @event_name = event_name
    @backend = backend

    backend.
      tracked_events_for(@user).
      named(@event_name).
      has_properties?(@properties)
  end

  description do
    "tracked event"
  end

  failure_message do |text|
    "expected event '#{@event_name}' to be tracked for user '#{@user}' with "\
    "included properties #{@properties} but was not"
  end

  failure_message_when_negated do |text|
    "expected event '#{@event_name}' not to be tracked for user '#{@user}' "\
      "with included properties #{@properties} but was"
  end

  chain(:for_user) { |user| @user = user }
  chain(:with_properties) { |properties| @properties = properties }
end
