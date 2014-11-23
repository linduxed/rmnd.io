class AddTimestampsToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :created_at, :datetime,
               null: false, default: Time.current
    change_column_default :reminders, :created_at, nil
    add_column :reminders, :updated_at, :datetime,
               null: false, default: Time.current
    change_column_default :reminders, :updated_at, nil
  end
end
