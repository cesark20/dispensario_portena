class CreateStockMovements < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_movements do |t|
      t.references :withdrawal_line, null: false, foreign_key: true
      t.references :item_batch, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :unit_value, precision: 10, scale: 2

      t.timestamps
    end
  end
end
