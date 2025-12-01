class MakeItemsProviderNotNull < ActiveRecord::Migration[7.2]
  def up
    change_column_null :items, :provider_id, false
  end
  def down
    change_column_null :items, :provider_id, true
  end
end
