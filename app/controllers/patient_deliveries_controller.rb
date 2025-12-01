class PatientDeliveriesController < ApplicationController
    def index
      patient_ids = Withdrawal.where.not(patient_id: nil).select(:patient_id).distinct
  
      @patients = User
                    .where(id: patient_ids, role: :patient)
                    .order(:last_name, :first_name) # ajustá si tu modelo usa otros campos
    end
  
    def show
      @patient = User.find(params[:id])
  
      @lines = WithdrawalLine
                 .joins(:withdrawal, :item)
                 .where(withdrawals: { patient_id: @patient.id })
                 .order("withdrawals.occurred_at DESC")
    end
  end