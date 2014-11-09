class AddEmailConfirmationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_confirmation_token, :string, limit: 128
    add_column :users, :email_confirmation_token_generated_at, :datetime
    add_column :users, :email_confirmed_at, :datetime
  end
end
