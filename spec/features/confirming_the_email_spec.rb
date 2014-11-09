require "rails_helper"

feature "Confirming the email" do
  scenario "with a valid token" do
    user = create(:user, email_confirmation_token: "valid")

    visit user_email_confirmation_path(user_id: user.id, token: "valid")

    expect(page).to have_content t("flashes.email_confirmed")
  end

  scenario "with an invalid token" do
    user = create(:user, email_confirmation_token: "valid")

    expect {
      visit user_email_confirmation_path(user_id: user.id, token: "invalid")
    }.to raise_exception(ActiveRecord::RecordNotFound)
  end
end
