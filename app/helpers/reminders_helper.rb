module RemindersHelper
  def reminder_class(reminder)
    if reminder.sent?
      "sent"
    end
  end
end
