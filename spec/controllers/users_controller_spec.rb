require "rails_helper"

describe UsersController do
  it { should deny_guest_access_to(get: :edit) }
  it { should deny_guest_access_to(patch: :update) }

  describe "#edit" do
    it "renders the edit template" do
      user = build_stubbed(:user)
      sign_in_as user

      get :edit

      expect(response).to render_template(:edit)
      expect(assigns[:user]).to eq user
    end
  end

  describe "#update" do
    context "when params are valid" do
      it "creates a reminder" do
        user = build_stubbed(:user)
        allow(user).to receive(:update).and_return(true)
        params = { time_zone: "Stockholm" }.with_indifferent_access
        sign_in_as user

        patch :update, user: params

        expect(user).to have_received(:update).with(params)
        expect(response).to redirect_to(reminders_path)
      end
    end

    context "when params are invalid" do
      it "renders the edit template" do
        user = build_stubbed(:user)
        allow(user).to receive(:update).and_return(false)
        params = { time_zone: "Stockholm" }.with_indifferent_access
        sign_in_as user

        patch :update, user: params

        expect(response).to render_template(:edit)
        expect(assigns[:user]).to eq user
      end
    end
  end
end
