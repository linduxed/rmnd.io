require "rails_helper"

describe UserLocator do
  describe "#call" do
    context "when a user can be found" do
      it "returns the found user" do
        user_factory = double("user_factory")
        user = double("user")
        not_found_strategy = double("not_found_strategy")
        allow(user_factory).to receive(:find_by).and_return(user)
        locator = UserLocator.new(
          user_factory: user_factory,
          not_found_strategy: not_found_strategy,
        )

        return_value = locator.call(email: "user@example.com")

        expect(user_factory).to have_received(:find_by).
          with(email: "user@example.com")
        expect(return_value).to eq(user)
      end
    end

    context "when a user can't be found" do
      it "returns whatever the not found strategy returns" do
        user_factory = double("user_factory")
        not_found_strategy = double("not_found_strategy")
        whatever = double("whatever")
        allow(user_factory).to receive(:find_by).and_return(nil)
        allow(not_found_strategy).to receive(:call).and_return(whatever)
        locator = UserLocator.new(
          user_factory: user_factory,
          not_found_strategy: not_found_strategy,
        )

        return_value = locator.call(email: "user@example.com")

        expect(user_factory).to have_received(:find_by).
          with(email: "user@example.com")
        expect(not_found_strategy).to have_received(:call).
          with(email: "user@example.com")
        expect(return_value).to eq(whatever)
      end
    end
  end
end
