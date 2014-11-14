class RemindersController < ApplicationController
  before_action :authorize

  def index
    @reminders = reminders.uncancelled.ordered
    @reminder = Reminder.new
  end

  def create
    @reminder = reminders.new(reminder_params)

    if @reminder.save
      analytics.track_add_reminder
      unless current_user.email_confirmed?
        flash.alert = t("flashes.email_unconfirmed")
      end
      redirect_to reminders_path, notice: t("flashes.reminder_added")
    else
      @reminders = reminders.uncancelled.ordered
      render :index
    end
  end

  def edit
    @reminder = unsent_reminders.find(params[:id])
  end

  def update
    @reminder = unsent_reminders.find(params[:id])
    if @reminder.update(reminder_params)
      analytics.track_edit_reminder
      redirect_to reminders_path, notice: t("flashes.reminder_updated")
    else
      render :edit
    end
  end

  private

  delegate :reminders, :unsent_reminders, to: :current_user

  def reminder_params
    params.require(:reminder).permit(
      :due_at,
      :repeat_frequency,
      :title,
    )
  end
end
