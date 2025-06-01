class Budget < ApplicationRecord
  # belonsgs_to :client, class_name: "User", foreign_key: "user_id"
  belongs_to :user
  has_many :budget_items, dependent: :destroy

  before_save :calculate_total

  def calculate_total
    budget_items.sum do |item|
      item.unit_price.to_f * item.quantity.to_i * (1 - item.discount.to_f / 100)
    end.round(2)
  end
  
  def update_total!
    update!(total: calculate_total)
  end
end
