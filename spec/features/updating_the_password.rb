require "rails_helper"

feature "Updating the password" do
  scenario "with valid password" do
    user = user_with_reset_password

    visit edit_user_password_path(
      user_id: user,
      token: user.confirmation_token
    )
    fill_in "password_reset_password", with: "password"
    click_button t("helpers.submit.password_reset.submit")

    expect(page).to have_button t("layouts.application.sign_out")
  end

  scenario "signs in with new password" do
    user = user_with_reset_password(email: "user@example.com")

    visit edit_user_password_path(
      user_id: user,
      token: user.confirmation_token
    )
    fill_in "password_reset_password", with: "password"
    click_button t("helpers.submit.password_reset.submit")
    click_button t("layouts.application.sign_out")
    visit sign_in_path
    fill_in "session_email", with: "user@example.com"
    fill_in "session_password", with: "password"
    click_button t("helpers.submit.session.submit")

    expect(page).to have_button t("layouts.application.sign_out")
  end

  scenario "tries with a blank password" do
    user = user_with_reset_password

    visit edit_user_password_path(
      user_id: user,
      token: user.confirmation_token
    )
    fill_in "password_reset_password", with: ""
    click_button t("helpers.submit.password_reset.submit")

    expect(page).to have_content t("flashes.failure_after_update")
    expect(page).not_to have_button t("layouts.application.sign_out")
  end

  private

  def user_with_reset_password(email: "user@example.com")
    user = create(:user, email: email)
    visit new_password_path
    fill_in "password_email", with: email
    click_button t("helpers.submit.password.submit")
    user.reload
  end
end
