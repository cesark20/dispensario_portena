class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.decimal :cost
      t.integer :available_quantity
      t.string :code

      t.timestamps
    end
  end
end
