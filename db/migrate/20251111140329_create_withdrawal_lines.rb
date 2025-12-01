class CreateWithdrawalLines < ActiveRecord::Migration[7.2]
  def change
    create_table :withdrawal_lines do |t|
      t.references :withdrawal, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :sale_unit_price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
