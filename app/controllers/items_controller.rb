class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]

  # GET /items
  def index
    @items = Item.includes(:item_batches, :provider).order(:name)
  end

  # GET /items/:id
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
    @item.item_batches.build
  end

  # GET /items/:id/edit
  def edit
    @item.item_batches.build if @item.item_batches.empty?
  end

  # POST /items
  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to @item, notice: "Insumo creado correctamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/:id
  def update
    if @item.update(item_params)
      redirect_to @item, notice: "Insumo actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /items/:id
  def destroy
    @item.destroy
    redirect_to items_url, notice: "Insumo eliminado correctamente."
  end

  # GET /items/reorder
  # Pantalla para ver el stock a reponer y seleccionar qué pedir
  def reorder
    @items = Item.includes(:item_batches, :provider).order(:name)
  end

  # POST /items/reorder_summary
  # Recibe los item_ids seleccionados y muestra campo de cantidades
  def reorder_summary
    item_ids = Array(params[:item_ids]).reject(&:blank?)

    if item_ids.empty?
      redirect_to reorder_items_path, alert: "Seleccioná al menos un insumo para reponer."
      return
    end

    @items = Item.includes(:provider).where(id: item_ids).order(:name)
  end

  # POST /items/reorder_pdf
  # Genera el PDF final agrupado por proveedor
  def reorder_pdf
    quantities_param = params[:quantities] || {}
  
    item_ids = quantities_param
                 .select { |_id, qty| qty.present? && qty.to_i > 0 }
                 .keys
  
    if item_ids.empty?
      redirect_to reorder_items_path, alert: "Indicá al menos una cantidad mayor a cero."
      return
    end
  
    items = Item.includes(:provider).where(id: item_ids)
  
    pdf = Prawn::Document.new(page_size: "A4")
    pdf.font_size 10
  
    pdf.text "Pedido de insumos", size: 18, style: :bold
    pdf.move_down 5
    pdf.text "Fecha: #{Date.current.strftime("%d-%m-%Y")}"
    pdf.move_down 10
  
    items.group_by(&:provider).each_with_index do |(provider, provider_items), index|
      pdf.start_new_page if index.positive?
  
      provider_name = provider&.name || "Sin proveedor asignado"
      pdf.text "Proveedor: #{provider_name}", size: 14, style: :bold
      pdf.move_down 10
  
      table_data = [["Insumo", "Cantidad a pedir"]]
  
      provider_items.each do |item|
        qty = quantities_param[item.id.to_s].to_i
        next if qty <= 0
  
        table_data << [item.name, qty]
      end
  
      pdf.table(table_data, header: true, width: pdf.bounds.width)
    end
  
    send_data pdf.render,
              filename: "pedido_insumos_#{Date.current}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(
      :name, :sku, :unit, :min_stock, :sale_price, :provider_id,
      item_batches_attributes: %i[id lot_code expires_on unit_cost quantity_on_hand _destroy]
    )
  end
end