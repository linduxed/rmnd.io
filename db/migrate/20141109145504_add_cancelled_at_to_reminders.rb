class AddCancelledAtToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :cancelled_at, :datetime
  end
end
