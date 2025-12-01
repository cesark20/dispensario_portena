class AddProviderToItems < ActiveRecord::Migration[7.2]
  def change
    add_reference :items, :provider, null: true, foreign_key: true
  end
end
