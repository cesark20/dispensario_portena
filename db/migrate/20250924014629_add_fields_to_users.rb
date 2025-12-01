class AddFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :address, :string
    add_column :users, :document_id, :string
    add_column :users, :status, :boolean
    add_column :users, :role, :integer, default: 3, null: false unless column_exists?(:users, :role)
  end
end
