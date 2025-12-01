class PatientInfo < ApplicationRecord
  belongs_to :user
  # Validaciones opcionales
  validates :birthdate, presence: true
end
