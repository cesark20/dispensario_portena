class CreateProviders < ActiveRecord::Migration[7.2]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :contact_name
      t.string :phone
      t.string :email
      t.string :address
      t.string :cuit
      t.boolean :status
      t.text :comments

      t.timestamps
    end
  end
end
