class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.string :name
      t.string :sku
      t.string :unit
      t.integer :min_stock
      t.decimal :sale_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
