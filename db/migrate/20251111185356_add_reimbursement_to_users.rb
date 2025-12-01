class AddReimbursementToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :reimbursement, :string, null: false, default: "none"

    # Backfill razonable:
    # - pacientes => none (paga 100% si no tiene carnet configurado)
    # - no pacientes (internos/enfermería/admin/etc.) => full (no pagan)
    execute <<~SQL
      UPDATE users
      SET reimbursement = CASE
        WHEN role = 'patient' THEN 'none'
        ELSE 'full'
      END
      WHERE reimbursement IS NULL OR reimbursement = '';
    SQL
  end

  def down
    remove_column :users, :reimbursement
  end
end