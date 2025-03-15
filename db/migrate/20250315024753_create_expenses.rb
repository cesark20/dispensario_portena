class CreateExpenses < ActiveRecord::Migration[7.2]
  def change
    create_table :expenses do |t|
      t.string :description
      t.string :company
      t.date :date
      t.string :responsible
      t.string :category
      t.decimal :amount_peso
      t.decimal :dollar_rate
      t.decimal :equivalent_usd
      t.decimal :amount_usd
      t.boolean :has_invoice
      t.text :comments

      t.timestamps
    end
  end
end
