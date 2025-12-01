class WithdrawalsController < ApplicationController
  before_action :load_people, only: [:new, :create]
  before_action :set_withdrawal, only: :show

  def index
    @withdrawals = Withdrawal.includes(:patient, :internal_user).order(occurred_at: :desc).limit(100)
  end

  def new
    @withdrawal = Withdrawal.new(occurred_at: Time.current, kind: "nursing", reimbursement: "full")
    @withdrawal.withdrawal_lines.build
  end

  def create
    @withdrawal = Withdrawal.new(withdrawal_params)
    @withdrawal.occurred_at ||= Time.current

    ActiveRecord::Base.transaction do
      @withdrawal.save!

      @withdrawal.withdrawal_lines.each do |line|
        line.sale_unit_price ||= line.item&.sale_price || 0
        moves = Stock::WithdrawItem.call!(item: line.item, quantity: line.quantity)
        moves.each do |m|
          line.stock_movements.create!(item_batch: m[:batch], quantity: m[:qty], unit_value: m[:unit_cost])
        end
      end

      gross = @withdrawal.withdrawal_lines.sum { |l| l.quantity.to_i * l.sale_unit_price.to_d }
      @withdrawal.update!(total_amount: gross * @withdrawal.pay_factor)
    end

    redirect_to withdrawal_path(@withdrawal), notice: "Egreso registrado."
  rescue => e
    flash.now[:alert] = @withdrawal.errors.full_messages.to_sentence.presence || e.message
    @withdrawal.withdrawal_lines.build if @withdrawal.withdrawal_lines.blank?
    render :new, status: :unprocessable_entity
  end

  def show
    # @withdrawal ya seteado por set_withdrawal
  end

  private

  def set_withdrawal
    @withdrawal = Withdrawal.includes(withdrawal_lines: [:item, :stock_movements]).find(params[:id])
  end

  def withdrawal_params
    params.require(:withdrawal).permit(
      :kind, :reimbursement, :patient_id, :internal_user_id, :occurred_at, :note,
      withdrawal_lines_attributes: [:item_id, :quantity, :sale_unit_price, :_destroy]
    )
  end

  # ⬇️ ESTE ES EL MÉTODO QUE FALTABA
  def load_people
    @patients = User.where(role: :patient)
                    .select(:id, :first_name, :last_name, :reimbursement)
                    .order(:last_name, :first_name)

    @nursing_users = User.where(role: :healthcare_staff)
                         .select(:id, :first_name, :last_name, :reimbursement)
                         .order(:last_name, :first_name)
  end
end