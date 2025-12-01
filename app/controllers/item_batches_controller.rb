class ItemBatchesController < ApplicationController
  before_action :set_item

  def create
    @item_batch = @item.item_batches.build(item_batch_params)
    if @item_batch.save
      redirect_to @item, notice: "Lote agregado correctamente."
    else
      redirect_to @item, alert: @item_batch.errors.full_messages.to_sentence
    end
  end

  def destroy
    @item.item_batches.find(params[:id]).destroy
    redirect_to @item, notice: "Lote eliminado."
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def item_batch_params
    params.require(:item_batch).permit(:lot_code, :expires_on, :unit_cost, :quantity_on_hand)
  end
end