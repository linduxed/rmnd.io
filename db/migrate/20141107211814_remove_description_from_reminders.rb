class RemoveDescriptionFromReminders < ActiveRecord::Migration
  def change
    remove_column :reminders, :description, :text
  end
end
