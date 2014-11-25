require "rails_helper"

describe CancellationsController do
  it {
    is_expected.to deny_guest_access_to(post: :create).with_params(reminder_id: '1')
  }

  describe "#create" do
    it "cancels the reminder" do
      user = build_stubbed(:user)
      reminder = build_stubbed(:reminder)
      allow(user.reminders).to receive(:find).and_return(reminder)
      allow(reminder).to receive(:cancel!)
      sign_in_as user

      post :create, reminder_id: '1'

      expect(user.reminders).to have_received(:find).with('1')
      expect(reminder).to have_received(:cancel!)
      expect(response).to redirect_to(reminders_path)
    end
  end
end
