class ClientsController < ApplicationController
  before_action :set_client, only: [:edit, :update]

  def index
    @clients = User.where(role: "client").includes(:client_info) # Traer client_info para evitar N+1 queries
  end

  def new
    @client = User.new(role: "client")
    @client.build_client_info # Para que el formulario incluya los campos de ClientInfo
    @client.vehicles.build # Para que el formulario incluya los campos de Vehicle
  end

  def create
    @client = User.new(client_params)
    @client.role = "client"
    @client.password = "password"
    if @client.save
      redirect_to clients_path, notice: "Cliente creado exitosamente."
    else
      puts "❌ Errores al guardar el usuario:"
      puts @client.errors.full_messages  # 👀 Mostrar los errores en consola
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @client.update(client_params)
      redirect_to clients_path, notice: "Cliente actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_client
    @client = User.find(params[:id])
  end

  def client_params
    params.require(:user).permit(
      :name, 
      :email, 
      client_info_attributes: [:id, :phone, :address, :tax_id, :business_name], 
      vehicles_attributes: [:id, :license_plate, :brand, :model, :year, :_destroy]
    )
  end
end
