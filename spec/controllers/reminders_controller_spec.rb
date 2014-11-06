require "rails_helper"

describe RemindersController do
  it { should deny_guest_access_to(get: :index) }
  it { should deny_guest_access_to(post: :create) }
end
