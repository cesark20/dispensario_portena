class InternalUsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  def index
    @internal_users = User.where.not(role: :client)
  end

  def edit
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.password = "overroad"
    if @user.save
      redirect_to internal_users_path, notice: "Usuario Interno creado exitosamente."
    else
      puts "❌ Errores al guardar el usuario:"
      puts @user.errors.full_messages  # 👀 Mostrar los errores en consola
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to internal_users_path, notice: "Usuario actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to internal_users_path, notice: "Usuario eliminado correctamente."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end

end
