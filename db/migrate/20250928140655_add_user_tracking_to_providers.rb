class AddUserTrackingToProviders < ActiveRecord::Migration[7.0]
  def change
    add_reference :providers, :created_by, foreign_key: { to_table: :users }
    add_reference :providers, :updated_by, foreign_key: { to_table: :users }
  end
end