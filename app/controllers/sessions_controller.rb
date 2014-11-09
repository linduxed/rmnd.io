class SessionsController < Clearance::SessionsController
  def create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success?
        analytics.track_sign_in
        redirect_back_or url_after_create
      else
        flash.now.alert = status.failure_message
        render :new, status: :unauthorized
      end
    end
  end

  def destroy
    analytics.track_sign_out
    sign_out
    redirect_to url_after_destroy
  end
end
