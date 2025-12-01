class Item < ApplicationRecord
  has_many :item_batches, dependent: :destroy

  has_many :withdrawal_lines, dependent: :nullify
    
  accepts_nested_attributes_for :item_batches, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true
  validates :min_stock, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :sale_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # stock físico total (incluye vencidos)
  def total_physical_on_hand
    item_batches.sum(:quantity_on_hand)
  end

  # stock disponible (solo lotes no vencidos)
  def total_on_hand
    item_batches.where("expires_on IS NULL OR expires_on >= ?", Date.current)
                .sum(:quantity_on_hand)
  end

  def low_stock?
    min_stock.present? && total_on_hand < min_stock
  end

  belongs_to :provider
end