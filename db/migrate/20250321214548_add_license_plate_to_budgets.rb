class AddLicensePlateToBudgets < ActiveRecord::Migration[7.2]
  def change
    add_column :budgets, :license_plate, :string
  end
end
