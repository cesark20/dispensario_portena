json.extract! item, :id, :name, :sku, :unit, :min_stock, :sale_price, :created_at, :updated_at
json.url item_url(item, format: :json)
