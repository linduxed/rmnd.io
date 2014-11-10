class AddTimeZoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string, null: false, default: "Stockholm"
    change_column_default :users, :time_zone, nil
  end
end
