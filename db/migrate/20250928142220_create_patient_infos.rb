class CreatePatientInfos < ActiveRecord::Migration[7.2]
  def change
    create_table :patient_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :health_insurance
      t.string :policy_number
      t.date :birthdate
      t.text :notes

      t.timestamps
    end
  end
end
