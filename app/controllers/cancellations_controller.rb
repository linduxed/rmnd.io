class CancellationsController < ApplicationController
  before_action :authorize

  def create
    reminder.cancel!
    analytics.track_cancel_reminder
    redirect_to reminders_path, notice: t("flashes.reminder_cancelled")
  end

  private

  def reminder
    current_user.reminders.find(params[:reminder_id])
  end
end
