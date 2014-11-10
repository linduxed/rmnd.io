class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_filter :with_user_time_zone, if: :signed_in?

  protected

  def analytics
    @analytics ||= Analytics.new(current_user)
  end

  def with_user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end
