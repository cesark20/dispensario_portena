class ShiftHandover < ApplicationRecord
  belongs_to :from_nurse, class_name: "User"
  belongs_to :to_nurse, class_name: "User"

  has_many :shift_handover_medications, dependent: :destroy
  accepts_nested_attributes_for :shift_handover_medications,
  allow_destroy: true,
  reject_if: proc { |attrs| attrs["medication_name"].blank? && attrs["quantity_reported"].blank? }
  
  STATUSES = %w[pending_validation validated disputed]

  validates :status, inclusion: { in: STATUSES }


  def status_es
    {
      "pending_validation" => "Pendiente de validación",
      "validated" => "Validado",
      "disputed" => "Con diferencias"
    }[status] || status
  end
end
