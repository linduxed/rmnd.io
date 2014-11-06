class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.timestamp null: false
      t.references :user, null: false, index: true
      t.string :title, null: false
      t.datetime :due_at, null: false
      t.datetime :sent_at
      t.text :description
      t.index [:due_at, :sent_at]
    end
  end
end
