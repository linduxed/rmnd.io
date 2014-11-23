class AddDueDateToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :due_date, :string
  end
end
