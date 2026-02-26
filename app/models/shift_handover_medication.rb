class ShiftHandoverMedication < ApplicationRecord
  belongs_to :shift_handover

  validates :medication_name, :quantity_reported, presence: true

  STATUSES_ES = {
    "ok"       => "OK",
    "mismatch" => "No coincide",
    "missing"  => "Faltante"
  }.freeze

  def status_es
    STATUSES_ES[status.to_s] || status.to_s.humanize
  end
  
end
