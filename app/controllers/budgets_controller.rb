class BudgetsController < ApplicationController
  before_action :set_budget, only: %i[show destroy edit update]

  def index
    @budgets = Budget.includes(:user).all
  end

  def new
    @budget = Budget.new
  end

  def create
    @budget = Budget.new(budget_params)
    
    if @budget.save
      if params[:budget][:items].present?
        params[:budget][:items].each do |index, item_data|
          BudgetItem.create!(
            budget: @budget,
            item_id: item_data[:id],
            item_type: item_data[:category] == "Stock" ? "Stock" : "Service",
            unit_price: item_data[:price].to_f,
            quantity: item_data[:quantity].to_i,
            discount: item_data[:discount].to_f
          )

        end 
        @budget.budget_items.reload
        @budget.update_total!
      end
      respond_to do |format|
        format.html { redirect_to budgets_path, notice: "Presupuesto creado correctamente" }
        format.json { render json: { success: true, redirect_url: budgets_path }, status: :created }
        format.turbo_stream { redirect_to budgets_path }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @budget.errors.full_messages }, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

require_dependency Rails.root.join("app/pdfs/budget_pdf.rb")

def show
  @budget = Budget.includes(:budget_items).find(params[:id])

  respond_to do |format|
    format.html
    format.pdf do
      pdf = BudgetPdf.new(@budget, current_user)
      send_data pdf.render, filename: "Presupuesto_Over_Road_#{@budget.id}.pdf",
                            type: "application/pdf",
                            disposition: "inline"
    end
  end
end

  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      if @budget.update(budget_params)
        # 1️⃣ Eliminar ítems seleccionados
        if params[:budget][:removed_items].present?
          removed_ids = params[:budget][:removed_items].split(",").map(&:to_i)
          BudgetItem.where(id: removed_ids).destroy_all
        end
  
        # 2️⃣ Actualizar o agregar nuevos ítems
        if params[:budget][:items].present?
          params[:budget][:items].each do |index, item_data|
            item = @budget.budget_items.find_by(item_id: item_data[:id], item_type: item_data[:category] == "Stock" ? "Stock" : "Service")
  
            if item
              # Si ya existe, lo actualizamos
              item.update!(
                unit_price: item_data[:price].to_f,
                quantity: item_data[:quantity].to_i,
                discount: item_data[:discount].to_f
              )
            else
              # Si no existe, lo creamos
              @budget.budget_items.create!(
                item_id: item_data[:id],
                item_type: item_data[:category] == "Stock" ? "Stock" : "Service",
                unit_price: item_data[:price].to_f,
                quantity: item_data[:quantity].to_i,
                discount: item_data[:discount].to_f
              )
            end
          end
        end

        @budget.update_total!
  
        respond_to do |format|
          format.html { redirect_to budgets_path, notice: "Presupuesto actualizado correctamente" }
          format.json { render json: { success: true, redirect_url: budgets_path }, status: :ok }
          format.turbo_stream { redirect_to budgets_path }
        end
      else
        raise ActiveRecord::Rollback
      end
    end
  rescue => e
    respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: { errors: e.message }, status: :unprocessable_entity }
      format.turbo_stream { render :edit, status: :unprocessable_entity }
    end
  end

  def destroy
    @budget.destroy
    redirect_to budgets_path, notice: "Budget deleted."
  end

  def search_items
    query = params[:query]&.downcase
  
    if query.blank?
      return render json: { error: "Query cannot be blank" }, status: :bad_request
    end
  
    @stocks = Stock.where("LOWER(name) LIKE ?", "%#{query}%")
    @services = Service.where("LOWER(name) LIKE ?", "%#{query}%")
  
    puts "🔎 Query: #{query}"
    puts "🛒 Stocks found: #{@stocks.size}"
    puts "🛠 Services found: #{@services.size}"
  
    results = (@stocks + @services).map do |item|
      {
        id: item.id,
        name: item.name,
        price: item.price.to_f, # 🔹 Convertir el precio a float correctamente
        category: item.is_a?(Stock) ? "Stock" : "Servicio" # 🔹 Devolver correctamente la categoría
      }
    end
  
    puts "📦 API Response: #{results.as_json}" # Debugging en servidor
  
    render json: results
  rescue => e
    puts "❌ Error in search_items: #{e.message}"
    render json: { error: e.message }, status: :internal_server_error
  end


  def send_email
    @budget = Budget.find(params[:id])
    BudgetMailer.send_budget(@budget, current_user).deliver_later
    redirect_to budgets_path, notice: "Presupuesto enviado por correo a #{@budget.user.email}"
  end

  private

  def set_budget
    @budget = Budget.find(params[:id])
  end

  def budget_params
    params.require(:budget).permit(:user_id, :date, :license_plate, budget_items_attributes: [:id, :item_id, :item_type, :quantity, :unit_price, :discount, :_destroy])
  end
end
