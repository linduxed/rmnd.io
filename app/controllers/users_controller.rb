class UsersController < Clearance::UsersController
  def create
    @user = user_from_params

    if @user.save
      sign_in @user
      @user.require_email_confirmation!
      Mailer.email_confirmation(@user).deliver
      analytics.track_sign_up
      flash.notice = t("flashes.signed_up")
      redirect_back_or url_after_create
    else
      render :new
    end
  end
end
