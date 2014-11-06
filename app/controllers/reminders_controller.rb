class RemindersController < ApplicationController
  before_action :authorize

  def index
    @reminders = reminders
    @reminder = Reminder.new
  end

  def create
    @reminder = reminders.new(reminder_params)

    if @reminder.save
      redirect_to reminders_path
    else
      @reminders = reminders
      render :index
    end
  end

  private

  delegate :reminders, to: :current_user

  def reminder_params
    params.require(:reminder).permit(:title, :due_at, :description)
  end
end
