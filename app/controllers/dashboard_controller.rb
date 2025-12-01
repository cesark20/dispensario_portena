class DashboardController < ApplicationController
  def index
    @items_to_reorder_count = Item.includes(:item_batches).select(&:low_stock?).count
    @total_expenses = 2 
    @total_budgets =  3
    @patients_count =  User.where(role: :patient).count
  end
end
