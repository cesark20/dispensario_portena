class InternalUsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @internal_users = User.where.not(role: :patient)
  end

  def new
    # status y login_enabled en true por defecto
    @user = User.new(status: true, login_enabled: true)
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.password = "eldispensario"
    @user.password_confirmation = "eldispensario"
  
    # valores por defecto
    @user.status = true if @user.status.nil?
    @user.login_enabled = true if @user.login_enabled.nil?
    @user.document_id ||= SecureRandom.hex(4)
    @user.reimbursement ||= "full"
  
    if @user.save
      redirect_to internal_users_path, notice: "Usuario Interno creado exitosamente."
    else
      puts "❌ Errores al guardar el usuario:"
      puts @user.errors.full_messages
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to internal_users_path, notice: "Usuario actualizado correctamente."
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to internal_users_path, notice: "Usuario eliminado correctamente."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # 👇 Acá está la clave
  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :address,
      :document_id,
      :role,
      :status,
      :login_enabled,
      :reimbursement
    )
  end
end