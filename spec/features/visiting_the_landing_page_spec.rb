require "rails_helper"

feature "Visiting the landing page" do
  scenario "when logged out" do
    visit root_path

    expect(current_path).to eq root_path
  end

  scenario "when logged in" do
    visit root_path(as: create(:user))

    expect(current_path).to eq reminders_path
  end
end
