require "rails_helper"

describe RemindersController do
  it { should deny_guest_access_to(get: :index) }
  it { should deny_guest_access_to(post: :create) }

  describe "#create" do
    context "when params are valid" do
      it "creates a reminder" do
        user = build_stubbed(:user)
        reminder = build_stubbed(:reminder)
        allow(user.reminders).to receive(:new).and_return(reminder)
        allow(reminder).to receive(:save).and_return(true)
        params = {
          description: "The good one.",
          due_at: "2014-11-07 21:38",
          repeat_frequency: "0",
          title: "Buy milk",
        }.with_indifferent_access
        sign_in_as user

        post :create, reminder: params

        expect(user.reminders).to have_received(:new).with(params)
        expect(reminder).to have_received(:save)
        expect(response).to redirect_to(reminders_path)
      end
    end

    context "when params are invalid" do
      it "renders the index template" do
        user = build_stubbed(:user)
        reminder = build_stubbed(:reminder)
        allow(user.reminders).to receive(:new).and_return(reminder)
        allow(reminder).to receive(:save).and_return(false)
        params = { title: "" }.with_indifferent_access
        sign_in_as user

        post :create, reminder: params

        expect(user.reminders).to have_received(:new).with(params)
        expect(reminder).to have_received(:save)
        expect(response).to render_template(:index)
        expect(assigns[:reminder]).to eq(reminder)
        expect(assigns[:reminders]).to eq(user.reminders)
      end
    end
  end
end
