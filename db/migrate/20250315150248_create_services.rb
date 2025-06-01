class CreateServices < ActiveRecord::Migration[7.2]
  def change
    create_table :services do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.decimal :cost
      t.integer :duration_minutes
      t.string :code

      t.timestamps
    end
  end
end
