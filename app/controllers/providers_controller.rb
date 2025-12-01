class ProvidersController < ApplicationController
    before_action :set_provider, only: %i[show edit update destroy]

    # GET /providers
    def index
        @providers = Provider.all.order(:name)
    end

    # GET /providers/1
    def show
    end

    # GET /providers/new
    def new
        @provider = Provider.new
    end

    # GET /providers/1/edit
    def edit
    end

    # POST /providers
    def create
        @provider = Provider.new(provider_params)
        # guardar quién lo creó (usá id o full_name según cómo tengas la columna)
        @provider.created_by = current_user    
        if @provider.save
          redirect_to providers_path, notice: "Proveedor creado correctamente."
        else
          Rails.logger.error(@provider.errors.full_messages)
          respond_to do |format|
            format.html         { render :new, status: :unprocessable_entity }
            format.turbo_stream { render :new, status: :unprocessable_entity }
          end
        end
      end

    # PATCH/PUT /providers/1
    def update
        # guardar quién lo modificó
        @provider.created_by = current_user    
        if @provider.update(provider_params)
          redirect_to providers_path, notice: "Proveedor actualizado correctamente."
        else
          render :edit, status: :unprocessable_entity
        end
      end
    
      # DELETE /providers/1
      def destroy
        if @provider.destroy
          redirect_to providers_url, notice: "Proveedor eliminado correctamente."
        else
          # Si falla por dependencias (items asociados), mostramos nuestro mensaje en español
          mensaje =
            if @provider.errors[:base].present?
              "No se puede eliminar el proveedor porque tiene insumos asociados."
            else
              @provider.errors.full_messages.to_sentence.presence ||
              "No se pudo eliminar el proveedor."
            end
      
          redirect_to providers_url, alert: mensaje
        end
      end

    private

    def set_provider
        @provider = Provider.find(params[:id])
    end

    def provider_params
        params.require(:provider).permit(
          :name,
          :contact_name,
          :phone,
          :email,
          :address,
          :cuit,
          :status,
          :comments
          # 👇 estas NO se permiten desde el form, las setea siempre el servidor
          # :created_by, :updated_by
        )
      end
end
