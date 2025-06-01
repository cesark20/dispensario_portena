class AddProviderToStocks < ActiveRecord::Migration[7.2]
  def change
    add_column :stocks, :provider, :string
  end
end
