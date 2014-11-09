require "rails_helper"

describe EmailConfirmationsController do
  describe "#update" do
    context "when the token is valid" do
      it "confirms the users email" do
        user = build_stubbed(:user)
        allow(User).to receive(:find_by!).and_return(user)
        allow(user).to receive(:confirm_email!)

        get :update, user_id: '1', token: 'valid'

        expect(User).to have_received(:find_by!).with(
          id: '1',
          email_confirmation_token: 'valid',
        )
        expect(user).to have_received(:confirm_email!)
      end
    end

    context "when the token is invalid" do
      it "does not confirm the users email" do
        user = build_stubbed(:user)
        allow(User).to receive(:find_by!).
          and_raise(ActiveRecord::RecordNotFound)
        allow(user).to receive(:confirm_email!)

        expect {
          get :update, user_id: '1', token: 'invalid'
        }.to raise_exception(ActiveRecord::RecordNotFound)

        expect(User).to have_received(:find_by!).with(
          id: '1',
          email_confirmation_token: 'invalid',
        )
        expect(user).not_to have_received(:confirm_email!)
      end
    end
  end
end
