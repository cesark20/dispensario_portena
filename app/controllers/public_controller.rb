class PublicController < ApplicationController
  skip_before_action :authenticate_user!
  
  def home
    @products = Stock.where(featured: true).limit(4)
  end

  def products
    @query = params[:query]
    products = Stock.all
    if @query.present?
      products = products.where(
        "name ILIKE :q OR description ILIKE :q OR code ILIKE :q",
        q: "%#{@query}%"
      )
    end
    @paginated_products = products.page(params[:page]).per(12)
  end

  def product
    @product = Stock.find(params[:id])
  end

  def services
    @query = params[:query]
    services = Service.all
    if @query.present?
      services = services.where(
        "name ILIKE :q OR description ILIKE :q OR code ILIKE :q",
        q: "%#{@query}%"
      )
    end
    @paginated_services = services.page(params[:page]).per(12)
  end

  def contact
  end

  def send_contact
    if request.post?
      name = params[:name]
      email = params[:email]
      message = params[:message]

      ContactMailer.contact_message(name, email, message).deliver_now
      flash[:notice] = "Gracias por tu mensaje. Te responderemos pronto."
      redirect_to contact_path
    end
  end
end
