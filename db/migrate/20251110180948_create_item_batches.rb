class CreateItemBatches < ActiveRecord::Migration[7.2]
  def change
    create_table :item_batches do |t|
      t.references :item, null: false, foreign_key: true
      t.string :lot_code
      t.date :expires_on
      t.decimal :unit_cost, precision: 10, scale: 2
      t.integer :quantity_on_hand

      t.timestamps
    end
  end
end
