class CreateBudgetItems < ActiveRecord::Migration[7.2]
  def change
    create_table :budget_items do |t|
      t.references :budget, null: false, foreign_key: true
      t.references :item, polymorphic: true, null: false
      t.integer :quantity
      t.decimal :unit_price
      t.decimal :discount

      t.timestamps
    end
  end
end
