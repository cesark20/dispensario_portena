class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  include Pundit::Authorization

  layout :layout_by_resource

  # Devise: permitir campos extra
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Campos extra en registro
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:first_name, :last_name, :phone, :address, :document_id, :reimbursement]
      # email y password los maneja Devise por defecto
    )

    # Campos extra en edición de cuenta (Devise)
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:first_name, :last_name, :phone, :address, :document_id, :reimbursement]
      # Nota: si querés permitir cambiar :role acá, agregalo conscientemente
      # keys: [..., :role]
    )
  end

  # Manejo de errores de autorización
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "No estás autorizado para realizar esta acción."
    redirect_to(request.referrer || root_path)
  end

  def layout_by_resource
    # Si es un controlador de Devise, usa el layout "devise"
    return "devise" if devise_controller?

    # Excepciones/overrides de layouts (ajustá según tus rutas)
    if (controller_path == "devise/invitations" && action_name != "edit") ||
       (controller_path == "devise_invitable/registrations" && action_name == "edit")
      return "application"
    end

    if controller_path.start_with?("public")
      return "public"
    end

    "application" # Por defecto, layout general
  end
end