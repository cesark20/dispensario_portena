class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user! 

  layout :layout_by_resource

  include Pundit::Authorization

  # Manejo de errores si un usuario intenta hacer algo sin permiso
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "No estás autorizado para realizar esta acción."
    redirect_to(request.referrer || root_path)
  end

  def layout_by_resource
    # Si es un controlador de Devise, usa el layout "devise"
    return "devise" if devise_controller?

    # Excepciones para ciertos controladores de Devise
    if (controller_path == "devise/invitations" && action_name != "edit") || 
       (controller_path == "devise_invitable/registrations" && action_name == "edit")
      return "application"
    end

    "application" # Por defecto, usa el layout general
  end
end
