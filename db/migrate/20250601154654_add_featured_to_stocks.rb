class AddFeaturedToStocks < ActiveRecord::Migration[7.2]
  def change
    add_column :stocks, :featured, :boolean
  end
end
