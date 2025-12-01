class DeliveriesController < ApplicationController

    # Lista de medicamentos que tuvieron entregas
    def index
      @items = Item
                 .joins(:withdrawal_lines)
                 .distinct
                 .order(:name)
    end
  
    # Entregas para un medicamento específico
    def show
      @item = Item.find(params[:id])
  
      @lines = WithdrawalLine
                 .joins(:withdrawal)
                 .includes(withdrawal: [:patient, :internal_user])
                 .where(item_id: @item.id)
                 .order("withdrawals.occurred_at DESC")
    end
  end