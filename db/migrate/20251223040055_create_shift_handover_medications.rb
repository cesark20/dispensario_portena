class CreateShiftHandoverMedications < ActiveRecord::Migration[7.2]
  def change
    create_table :shift_handover_medications do |t|
      t.references :shift_handover, null: false, foreign_key: true
      t.string :medication_name
      t.string :dose
      t.integer :quantity_reported
      t.integer :quantity_received
      t.string :status
      t.text :comment

      t.timestamps
    end
  end
end
