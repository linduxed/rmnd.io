require "rails_helper"

describe SignUp do
  describe "#call" do
    it "creates a user" do
      user_factory = double("user_factory")
      user = double("user")
      analytics_factory = double("analytics_factory")
      analytics = double("analytics")
      allow(user_factory).to receive(:create!).and_return(user)
      allow(analytics_factory).to receive(:new).and_return(analytics)
      allow(analytics).to receive(:track_sign_up)
      sign_up = SignUp.new(
        user_factory: user_factory,
        analytics_factory: analytics_factory,
      )

      return_value = sign_up.call(email: "user@example.com")

      expect(user_factory).to have_received(:create!).
        with(email: "user@example.com")
      expect(analytics_factory).to have_received(:new).with(user)
      expect(analytics).to have_received(:track_sign_up)
      expect(return_value).to eq(user)
    end
  end
end
