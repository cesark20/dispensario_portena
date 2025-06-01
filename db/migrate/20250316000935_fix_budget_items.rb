class FixBudgetItems < ActiveRecord::Migration[7.2]
  def change
    change_column :budget_items, :unit_price, :decimal, precision: 10, scale: 2
    change_column :budget_items, :discount, :decimal, precision: 5, scale: 2, default: 0.0
    change_column_default :budget_items, :quantity, 1
  end
end
