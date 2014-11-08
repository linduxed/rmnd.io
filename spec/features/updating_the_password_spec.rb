require "rails_helper"

feature "Updating the password" do
  scenario "with valid password" do
    user = user_with_reset_password

    visit edit_user_password_path(
      user_id: user,
      token: user.confirmation_token
    )
    fill_in field("password_reset.password"), with: "password"
    click_button button("password_reset.submit")

    expect(page).to have_button t("layouts.application.sign_out")
  end

  scenario "signs in with new password" do
    user = user_with_reset_password(email: "user@example.com")

    visit edit_user_password_path(
      user_id: user,
      token: user.confirmation_token
    )
    fill_in field("password_reset.password"), with: "password"
    click_button button("password_reset.submit")
    click_button t("layouts.application.sign_out")
    visit sign_in_path
    fill_in field("session.email"), with: "user@example.com"
    fill_in field("session.password"), with: "password"
    click_button button("session.submit")

    expect(page).to have_button t("layouts.application.sign_out")
  end

  scenario "tries with a blank password" do
    user = user_with_reset_password

    visit edit_user_password_path(
      user_id: user,
      token: user.confirmation_token
    )
    fill_in field("password_reset.password"), with: ""
    click_button button("password_reset.submit")

    expect(page).to have_content t("flashes.failure_after_update")
    expect(page).not_to have_button t("layouts.application.sign_out")
  end

  private

  def user_with_reset_password(email: "user@example.com")
    user = create(:user, email: email)
    visit new_password_path
    fill_in field("password.email"), with: email
    click_button button("password.submit")
    user.reload
  end
end
