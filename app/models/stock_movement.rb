class StockMovement < ApplicationRecord
  belongs_to :withdrawal_line
  belongs_to :item_batch

  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_value, numericality: { greater_than_or_equal_to: 0 }
end