require "rails_helper"

describe User do
  describe "assocations" do
    it { should have_many(:reminders).dependent(:destroy) }
  end
end
