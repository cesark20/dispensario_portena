class AddLoginEnabledToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :login_enabled, :boolean, default: true, null: false
  end
end
