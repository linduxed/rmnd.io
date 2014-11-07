class HomePagesController < ApplicationController
  def show
    if signed_in?
      redirect_to reminders_path
    end
  end
end
