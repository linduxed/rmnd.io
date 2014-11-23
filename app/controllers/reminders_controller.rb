class RemindersController < ApplicationController
  before_action :authorize

  def index
    @reminders = reminders.uncancelled.ordered
    @reminder_form = ReminderForm.new
  end

  def create
    @reminder_form = ReminderForm.new(reminder_form_params)

    if @reminder_form.save(reminder_factory: reminders)
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
    @reminder_form = ReminderForm.find(
      params[:id],
      reminder_factory: unsent_reminders,
    )
  end

  def update
    @reminder_form = ReminderForm.find(
      params[:id],
      reminder_factory: unsent_reminders,
    )

    if @reminder_form.update(reminder_form_params)
      analytics.track_edit_reminder
      redirect_to reminders_path, notice: t("flashes.reminder_updated")
    else
      render :edit
    end
  end

  private

  delegate :reminders, :unsent_reminders, to: :current_user

  def reminder_form_params
    params.require(:reminder_form).permit(
      :due_date,
      :repeat_frequency,
      :title,
    )
  end
end
