class ShiftHandoversController < ApplicationController
  before_action :authenticate_user!
  before_action :require_shift_handover_reader!, only: [:index, :show]

  before_action :require_healthcare_staff!, only: [:new, :create, :validate_handover, :dispute]
  before_action :set_shift_handover, only: [ :show, :validate_handover, :dispute ]
  # before_action :block_superadmin!, only: [:new, :create, :validate_handover, :dispute]


  def index
    base = ShiftHandover.includes(:from_nurse, :to_nurse).order(created_at: :desc)

    if current_user.role == "admin"
      @shift_handovers = base
    else
      @shift_handovers = base.where("from_nurse_id = ? OR to_nurse_id = ?", current_user.id, current_user.id)
    end
  end
  
  
  def new
    @shift_handover = ShiftHandover.new
    15.times { @shift_handover.shift_handover_medications.build }
    @healthcare_staff = User.where(role: "healthcare_staff").where.not(id: current_user.id).order(:email)
  end

  def create
    @shift_handover = ShiftHandover.new(shift_handover_params)
    @shift_handover.from_nurse = current_user
    @shift_handover.status = "pending_validation"

    if @shift_handover.save
      redirect_to @shift_handover, notice: "Entrega de turno creada."
    else
      @healthcare_staff = User.where(role: "healthcare_staff").where.not(id: current_user.id).order(:email)
    
      missing = 15 - @shift_handover.shift_handover_medications.size
      missing.times { @shift_handover.shift_handover_medications.build } if missing.positive?
    
      render :new
    end
  end

  def show; end

  def validate_handover
    return head :forbidden unless @shift_handover.to_nurse == current_user

    ActiveRecord::Base.transaction do
      update_medications_from_validation!

      if any_mismatch?
        @shift_handover.update!(status: "disputed")
      else
        @shift_handover.update!(status: "validated", validated_at: Time.current)
      end
    end

    redirect_to @shift_handover
  end

  def dispute
    return head :forbidden unless @shift_handover.to_nurse == current_user
    @shift_handover.update!(status: "disputed")
    redirect_to @shift_handover, alert: "Entrega marcada como con diferencias."
  end

  

  private

  def require_shift_handover_reader!
    allowed = %w[healthcare_staff admin]
    unless current_user.respond_to?(:role) && allowed.include?(current_user.role)
      redirect_to root_path, alert: "No tenés permisos para ver entregas de turno."
    end
  end

  def require_healthcare_staff!
    unless current_user.respond_to?(:role) && current_user.role == "healthcare_staff"
      redirect_to root_path, alert: "Solo personal de salud puede operar entregas de turno."
    end
  end

  def set_shift_handover
    @shift_handover = ShiftHandover.find(params[:id])
  end

  def shift_handover_params
    params.require(:shift_handover).permit(
      :to_nurse_id,
      :cash_received, :cash_generated, :cash_delivered,
      :observations,
      shift_handover_medications_attributes: [
        :id, :medication_name, :dose, :quantity_reported, :_destroy
      ]
    )
  end

  def validation_params
    params.require(:shift_handover).permit(
      shift_handover_medications_attributes: [:id, :quantity_received, :comment]
    )
  end

  def update_medications_from_validation!
    attrs = validation_params[:shift_handover_medications_attributes] || []
  
    items =
      case attrs
      when ActionController::Parameters
        attrs.values
      when Hash
        attrs.values
      when Array
        attrs
      else
        []
      end
  
    items.each do |m|
      med = @shift_handover.shift_handover_medications.find(m[:id])
  
      received_str = m[:quantity_received].to_s.strip
      received_int = received_str.present? ? received_str.to_i : nil
  
      med.update!(
        quantity_received: received_int,
        comment: m[:comment],
        status: (received_int.present? && received_int != med.quantity_reported) ? "mismatch" : "ok"
      )
    end
  end

  def any_mismatch?
    @shift_handover.shift_handover_medications.any? { |m| m.status == "mismatch" }
  end
end
