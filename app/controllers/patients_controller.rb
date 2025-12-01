# app/controllers/patients_controller.rb
class PatientsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!  # o tu guard de permisos
    before_action :set_patient, only: [:show, :edit, :update, :destroy]
  
    def index
      @patients = User.patient.order(created_at: :desc).includes(:patient_info)
    end
  
    def show; end
  
    def new
      @patient = User.new(role: :patient, login_enabled: false)
      @patient.build_patient_info
    end
  
    def create
      @patient = User.new(patient_params)
      @patient.role = :patient
      @patient.login_enabled = false
      # fijá el status por defecto
      @patient.status = :active   # o :inactive, según tu negocio
    
      @patient.password = SecureRandom.hex(12)
      @patient.password_confirmation = @patient.password
    
      if @patient.save
        redirect_to patients_path, notice: "Paciente creado con éxito."
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
      @patient.build_patient_info unless @patient.patient_info
    end
  
    def update
      # si querés siempre activo:
      @patient.status = :active
      if @patient.update(patient_params)
        redirect_to patients_path, notice: "Paciente actualizado con éxito."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @patient.destroy
      redirect_to patients_path, notice: "Paciente eliminado con éxito."
    end
  
    private
  
    def set_patient
      @patient = User.patient.find(params[:id])
    end
  
    def patient_params
      params.require(:user).permit(
        :first_name, :last_name, :document_id, :phone, :address, :email,
        patient_info_attributes: [:id, :health_insurance, :policy_number, :birthdate, :notes, :reimbursement]
      )
    end
  
    def require_admin!
      redirect_to root_path, alert: "No autorizado" unless current_user.admin?
    end
  end