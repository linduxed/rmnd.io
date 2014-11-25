require "rails_helper"

describe User do
  describe "assocations" do
    it { is_expected.to have_many(:reminders).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_presence_of(:time_zone) }
    it {
      is_expected.to validate_inclusion_of(:time_zone).
        in_array(ActiveSupport::TimeZone.all.map(&:name))
    }
  end

  describe "delegations" do
    it { is_expected.to delegate_method(:unsent_reminders).to(:reminders).as(:unsent) }
  end

  describe "#require_email_confirmation!" do
    context "for a user without a confirmed email" do
      it "generates a new email confirmation token" do
        user = create(
          :user,
          email_confirmed_at: nil,
          email_confirmation_token: nil,
        )

        user.require_email_confirmation!

        user.reload
        expect(user.email_confirmed_at).to be_nil
        expect(user.email_confirmation_token).to be_present
      end
    end

    context "for a user with a confirmed email" do
      it "unconfirms the users email and generates a new token" do
        user = create(
          :user,
          email_confirmed_at: Time.current,
          email_confirmation_token: nil,
        )

        user.require_email_confirmation!

        user.reload
        expect(user.email_confirmed_at).to be_nil
        expect(user.email_confirmation_token).to be_present
      end
    end
  end

  describe "#confirm_email!" do
    it "confirms the users email" do
      travel_to Time.current.beginning_of_minute do
        user = create(
          :user,
          email_confirmed_at: nil,
        )

        user.confirm_email!

        user.reload
        expect(user.email_confirmed_at).to eq(Time.current)
      end
    end
  end

  describe "#email_confirmed?" do
    context "when the email is confirmed" do
      it "returns true" do
        user = described_class.new(email_confirmed_at: Time.current)

        expect(user.email_confirmed?).to eq(true)
      end
    end

    context "when the email is not confirmed" do
      it "returns false" do
        user = described_class.new(email_confirmed_at: nil)

        expect(user.email_confirmed?).to eq(false)
      end
    end
  end
end
