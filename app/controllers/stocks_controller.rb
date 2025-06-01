class StocksController < ApplicationController
  before_action :set_stock, only: %i[edit update destroy]

  def index
    @stocks = Stock.all
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = Stock.new(stock_params_with_images)
    if @stock.save
      redirect_to stocks_path, notice: "Product successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  

  def edit; end

  def update
    if @stock.update(stock_params)
      if params[:stock][:images]
        params[:stock][:images].each do |image|
          @stock.images.attach(image)
        end
      end
      redirect_to stocks_path, notice: "Product updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stock.destroy
    redirect_to stocks_path, notice: "Product deleted."
  end

  def purge_image
    image = ActiveStorage::Attachment.find(params[:image_id])
    image.purge
    redirect_back fallback_location: edit_stock_path(params[:id]), notice: "Imagen eliminada"
  end

  def delete_image
    @stock = Stock.find(params[:id])
    image = @stock.images.find(params[:image_id])
    image.purge
  
    redirect_to edit_stock_path(@stock), notice: "Imagen eliminada correctamente."
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params_with_images
    params.require(:stock).permit(:name, :description, :provider, :price, :cost, :featured, :available_quantity, :code, images: [])
  end

  def stock_params
    params.require(:stock).permit(:name, :description, :provider, :price, :cost, :featured, :available_quantity, :code)
  end
end
