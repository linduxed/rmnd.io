require "rails_helper"

describe RemindersController do
  it { should deny_guest_access_to(get: :index) }
  it { should deny_guest_access_to(post: :create) }
  it { should deny_guest_access_to(get: :edit).with_params(id: "1") }
  it { should deny_guest_access_to(patch: :update).with_params(id: "1") }

  describe "#create" do
    context "when params are valid" do
      it "creates a reminder" do
        user = build_stubbed(:user)
        reminder = build_stubbed(:reminder)
        decorated_reminder = double(:decorated_reminder)
        allow(user.reminders).to receive(:new).and_return(reminder)
        allow(FutureReminder).to receive(:new).and_return(decorated_reminder)
        allow(decorated_reminder).to receive(:save).and_return(true)
        params = {
          due_at: "2014-11-07 21:38",
          repeat_frequency: "daily",
          title: "Buy milk",
        }.with_indifferent_access
        sign_in_as user

        post :create, reminder: params

        expect(user.reminders).to have_received(:new).with(params)
        expect(FutureReminder).to have_received(:new).with(reminder)
        expect(decorated_reminder).to have_received(:save)
        expect(response).to redirect_to(reminders_path)
      end
    end

    context "when params are invalid" do
      it "renders the index template" do
        user = build_stubbed(:user)
        reminder = build_stubbed(:reminder)
        decorated_reminder = double(:decorated_reminder)
        allow(user.reminders).to receive(:new).and_return(reminder)
        allow(FutureReminder).to receive(:new).and_return(decorated_reminder)
        allow(decorated_reminder).to receive(:save).and_return(false)
        params = { title: "" }.with_indifferent_access
        sign_in_as user

        post :create, reminder: params

        expect(user.reminders).to have_received(:new).with(params)
        expect(FutureReminder).to have_received(:new).with(reminder)
        expect(decorated_reminder).to have_received(:save)
        expect(response).to render_template(:index)
        expect(assigns[:reminder]).to eq(decorated_reminder)
        expect(assigns[:reminders]).to eq(user.reminders)
      end
    end
  end

  describe "#edit" do
    it "renders the edit template" do
      user = build_stubbed(:user)
      reminder = build_stubbed(:reminder)
      unsent_reminders = double(:unsent_reminders)
      decorated_reminder = double(:decorated_reminder)
      allow(user).to receive(:unsent_reminders).and_return(unsent_reminders)
      allow(unsent_reminders).to receive(:find).and_return(reminder)
      allow(FutureReminder).to receive(:new).and_return(decorated_reminder)
      sign_in_as user

      get :edit, id: "1"

      expect(unsent_reminders).to have_received(:find).with("1")
      expect(FutureReminder).to have_received(:new).with(reminder)
      expect(response).to render_template(:edit)
      expect(assigns[:reminder]).to eq(decorated_reminder)
    end
  end

  describe "#update" do
    context "when params are valid" do
      it "updates the reminder" do
        user = build_stubbed(:user)
        reminder = build_stubbed(:reminder)
        unsent_reminders = double(:unsent_reminders)
        decorated_reminder = double(:decorated_reminder)
        allow(user).to receive(:unsent_reminders).and_return(unsent_reminders)
        allow(unsent_reminders).to receive(:find).and_return(reminder)
        allow(FutureReminder).to receive(:new).and_return(decorated_reminder)
        allow(decorated_reminder).to receive(:update).and_return(true)
        params = {
          due_at: "2014-11-07 21:38",
          repeat_frequency: "daily",
          title: "Buy milk",
        }.with_indifferent_access
        sign_in_as user

        patch :update, id: "1", reminder: params

        expect(unsent_reminders).to have_received(:find).with("1")
        expect(FutureReminder).to have_received(:new).with(reminder)
        expect(decorated_reminder).to have_received(:update).with(params)
        expect(response).to redirect_to(reminders_path)
      end
    end

    context "when params are invalid" do
      it "renders the edit template" do
        user = build_stubbed(:user)
        reminder = build_stubbed(:reminder)
        unsent_reminders = double(:unsent_reminders)
        decorated_reminder = double(:decorated_reminder)
        allow(user).to receive(:unsent_reminders).and_return(unsent_reminders)
        allow(unsent_reminders).to receive(:find).and_return(reminder)
        allow(FutureReminder).to receive(:new).and_return(decorated_reminder)
        allow(decorated_reminder).to receive(:update).and_return(false)
        params = {
          due_at: "2014-11-07 21:38",
          repeat_frequency: "daily",
          title: "Buy milk",
        }.with_indifferent_access
        sign_in_as user

        patch :update, id: "1", reminder: params

        expect(unsent_reminders).to have_received(:find).with("1")
        expect(FutureReminder).to have_received(:new).with(reminder)
        expect(decorated_reminder).to have_received(:update).with(params)
        expect(response).to render_template(:edit)
        expect(assigns[:reminder]).to eq(decorated_reminder)
      end
    end
  end
end
