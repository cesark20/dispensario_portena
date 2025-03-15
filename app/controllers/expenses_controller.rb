class ExpensesController < ApplicationController
  before_action :set_expense, only: [:edit, :update, :destroy]

  def index
    @expenses = Expense.order(date: :desc)
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      redirect_to expenses_path, notice: "Gasto registrado con éxito."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @expense.update(expense_params)
      redirect_to expenses_path, notice: "Gasto actualizado con éxito."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path, notice: "Gasto eliminado con éxito."
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:description, :company, :date, :responsible, :category, :amount_peso, :dollar_rate, :equivalent_usd, :amount_usd, :has_invoice, :comments)
  end
end
