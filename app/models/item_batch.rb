class ItemBatch < ApplicationRecord
  belongs_to :item

  validates :quantity_on_hand, numericality: { greater_than_or_equal_to: 0 }
  validates :unit_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :valid_non_expired, -> { where("expires_on IS NULL OR expires_on >= ?", Date.current) }
  scope :ordered_for_fifo,  -> { order(Arel.sql("expires_on NULLS LAST"), :created_at) }
end