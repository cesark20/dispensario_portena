class CreateClientInfos < ActiveRecord::Migration[7.2]
  def change
    create_table :client_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :address
      t.string :phone
      t.string :tax_id
      t.string :business_name

      t.timestamps
    end
  end
end
