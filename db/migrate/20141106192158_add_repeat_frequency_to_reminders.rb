class AddRepeatFrequencyToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :repeat_frequency, :integer
  end
end
