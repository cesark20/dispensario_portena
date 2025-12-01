class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { admin: 0, pharmacy: 1, healthcare_staff: 2, patient: 3, superadmin: 4 }

  ROLE_LABELS = {
    "admin"           => "Administrador",
    "pharmacy"        => "Farmacia",
    "healthcare_staff"=> "Personal de salud",
    "patient"         => "Paciente",
    "superadmin"      => "Superadministrador"
  }.freeze
  
  def role_label
    ROLE_LABELS[role] || role.to_s
  end

  validates :first_name, :last_name, :phone, :address, :document_id, presence: true
  validates :email, presence: true, uniqueness: true
  validates :status, inclusion: { in: [true, false] }

  has_one :patient_info, dependent: :destroy
  accepts_nested_attributes_for :patient_info, update_only: true

  def active_for_authentication?
    super && login_enabled
  end

  # ==== REINTEGRO ====
  VALID_REIMBURSEMENTS = %w[full half none].freeze

  # validación SUAVE: solo cuando viene algo, y se permite nil
  validates :reimbursement, inclusion: { in: VALID_REIMBURSEMENTS }, allow_nil: true

  before_validation :default_reimbursement_for_non_patients

  def full_name
    [last_name, first_name].compact.join(", ").presence || email
  end

  private

  def default_reimbursement_for_non_patients
    # si no trae nada, seteamos por defecto:
    # pacientes => "none" (paga todo)
    # resto     => "full" (no paga)
    self.reimbursement ||= (role == "patient" ? "none" : "full")
  end
end