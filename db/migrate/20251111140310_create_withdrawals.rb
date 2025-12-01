class CreateWithdrawals < ActiveRecord::Migration[7.0]
  def change
    create_table :withdrawals do |t|
      t.string :kind, null: false                            # "patient" | "nursing"
      t.string :reimbursement, null: false                   # "full" | "half" | "none"

      # IMPORTANTE: referenciar a users
      t.references :patient,       foreign_key: { to_table: :users }, null: true
      t.references :internal_user, foreign_key: { to_table: :users }, null: true

      t.decimal  :total_amount, precision: 10, scale: 2, default: 0
      t.datetime :occurred_at, null: false
      t.text     :note
      t.timestamps
    end
  end
end