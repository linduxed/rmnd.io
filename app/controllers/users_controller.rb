class UsersController < Clearance::UsersController
  before_action :authorize, except: [:new, :create]

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

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_update_params)
      analytics.track_edit_settings
      redirect_to reminders_path, notice: t("flashes.settings_updated")
    else
      render :edit
    end
  end

  private

  def user_from_params
    User.new(user_params)
  end

  def user_params
    params.fetch(:user, {}).permit(:email, :password, :time_zone)
  end

  def user_update_params
    params.require(:user).permit(:time_zone)
  end
end
