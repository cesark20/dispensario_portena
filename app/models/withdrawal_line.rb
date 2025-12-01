class WithdrawalLine < ApplicationRecord
  belongs_to :withdrawal
  belongs_to :item
  has_many :stock_movements, dependent: :destroy

  validates :quantity, numericality: { greater_than: 0 }
  validates :sale_unit_price, numericality: true

  before_validation :set_sale_price_from_item, if: -> { sale_unit_price.blank? && item.present? }

  private
  def set_sale_price_from_item
    self.sale_unit_price = item.sale_price
  end
end