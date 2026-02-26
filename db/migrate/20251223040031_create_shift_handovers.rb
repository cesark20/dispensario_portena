class CreateShiftHandovers < ActiveRecord::Migration[7.2]
  def change
    create_table :shift_handovers do |t|
      t.references :from_nurse, users: true, null: false, foreign_key: true
      t.references :to_nurse, users: true, null: false, foreign_key: true
      t.decimal :cash_received
      t.decimal :cash_generated
      t.decimal :cash_delivered
      t.text :observations
      t.string :status
      t.datetime :validated_at

      t.timestamps
    end
  end
end
