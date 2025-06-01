class CreateBudgets < ActiveRecord::Migration[7.2]
  def change
    create_table :budgets do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.decimal :total
      t.decimal :global_discount
      t.string :status

      t.timestamps
    end
  end
end
