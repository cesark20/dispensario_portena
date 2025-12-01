module Stock
    class WithdrawItem
      # consume quantity from batches FIFO (by expires_on asc, then created_at)
      def self.call!(item:, quantity:)
        raise ArgumentError, "quantity must be > 0" unless quantity.to_i > 0
  
        remaining = quantity.to_i
        batches = item.item_batches.where("expires_on IS NULL OR expires_on >= ?", Date.current)
                                   .order(Arel.sql("expires_on NULLS LAST"), :created_at)
                                   .lock # FOR UPDATE en transacción
  
        moves = []
        batches.each do |batch|
          break if remaining <= 0
          take = [batch.quantity_on_hand, remaining].min
          next if take <= 0
  
          batch.update!(quantity_on_hand: batch.quantity_on_hand - take)
          moves << { batch: batch, qty: take, unit_cost: batch.unit_cost.to_d }
          remaining -= take
        end
  
        raise StandardError, "Stock insuficiente" if remaining > 0
        moves
      end
    end
  end