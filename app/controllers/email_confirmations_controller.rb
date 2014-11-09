class EmailConfirmationsController < ApplicationController
  def update
    user = User.find_by!(id: params[:user_id], email_confirmation_token: params[:token])
    user.confirm_email!
    redirect_to root_path, notice: t("flashes.email_confirmed")
  end
end
