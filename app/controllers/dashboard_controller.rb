class DashboardController < ApplicationController
  def index
    @total_stock_items = Stock.sum(:available_quantity) 
    @total_expenses = Expense.sum(:amount_peso) 
    @total_budgets =  Budget.count()
    @total_clients =  User.where(role: "client").count()
  end
end
