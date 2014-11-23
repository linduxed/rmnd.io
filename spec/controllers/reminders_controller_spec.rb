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
        reminder_form = double(:reminder_form)
        allow(ReminderForm).to receive(:new).and_return(reminder_form)
        allow(reminder_form).to receive(:save).and_return(true)
        params = {
          due_date: "2014-11-07 21:38",
          repeat_frequency: "daily",
          title: "Buy milk",
        }.with_indifferent_access
        sign_in_as user

        post :create, reminder_form: params

        expect(ReminderForm).to have_received(:new).with(params)
        expect(reminder_form).to have_received(:save).
          with(reminder_factory: user.reminders)
        expect(response).to redirect_to(reminders_path)
      end
    end

    context "when params are invalid" do
      it "renders the index template" do
        user = build_stubbed(:user)
        reminder_form = double(:reminder_form)
        allow(ReminderForm).to receive(:new).and_return(reminder_form)
        allow(reminder_form).to receive(:save).and_return(false)
        params = { title: "" }.with_indifferent_access
        sign_in_as user

        post :create, reminder_form: params

        expect(ReminderForm).to have_received(:new).with(params)
        expect(reminder_form).to have_received(:save).
          with(reminder_factory: user.reminders)
        expect(response).to render_template(:index)
        expect(assigns[:reminder_form]).to eq(reminder_form)
        expect(assigns[:reminders]).to eq(user.reminders)
      end
    end
  end

  describe "#edit" do
    it "renders the edit template" do
      user = build_stubbed(:user)
      reminder_form = double(:reminder_form)
      allow(ReminderForm).to receive(:find).and_return(reminder_form)
      sign_in_as user

      get :edit, id: "1"

      expect(ReminderForm).to have_received(:find).
        with("1", reminder_factory: user.unsent_reminders)
      expect(response).to render_template(:edit)
      expect(assigns[:reminder_form]).to eq(reminder_form)
    end
  end

  describe "#update" do
    context "when params are valid" do
      it "updates the reminder" do
        user = build_stubbed(:user)
        reminder_form = double(:reminder_form)
        allow(ReminderForm).to receive(:find).and_return(reminder_form)
        allow(reminder_form).to receive(:update).and_return(true)
        params = {
          due_date: "2014-11-07 21:38",
          repeat_frequency: "daily",
          title: "Buy milk",
        }.with_indifferent_access
        sign_in_as user

        patch :update, id: "1", reminder_form: params

        expect(ReminderForm).to have_received(:find).
          with("1", reminder_factory: user.unsent_reminders)
        expect(reminder_form).to have_received(:update).with(params)
        expect(response).to redirect_to(reminders_path)
      end
    end

    context "when params are invalid" do
      it "renders the edit template" do
        user = build_stubbed(:user)
        reminder_form = double(:reminder_form)
        allow(ReminderForm).to receive(:find).and_return(reminder_form)
        allow(reminder_form).to receive(:update).and_return(false)
        params = {
          due_date: "2014-11-07 21:38",
          repeat_frequency: "daily",
          title: "Buy milk",
        }.with_indifferent_access
        sign_in_as user

        patch :update, id: "1", reminder_form: params

        expect(ReminderForm).to have_received(:find).
          with("1", reminder_factory: user.unsent_reminders)
        expect(reminder_form).to have_received(:update).with(params)
        expect(response).to render_template(:edit)
        expect(assigns[:reminder_form]).to eq(reminder_form)
      end
    end
  end
end
