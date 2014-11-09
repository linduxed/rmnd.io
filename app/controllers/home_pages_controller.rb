class HomePagesController < ApplicationController
  def show
    if signed_in?
      redirect_to reminders_path
    else
      @user = User.new
    end
  end
end
