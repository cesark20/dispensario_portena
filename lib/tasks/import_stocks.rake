require 'csv'

namespace :import do
  desc "Import stock from CSV"
  task stocks: :environment do
    file_path = "public/stock_import_prod.csv" # Ruta donde subirás el CSV

    CSV.foreach(file_path, headers: true, col_sep: ",", encoding: "ISO-8859-1:UTF-8") do |row|
      # Limpiar y convertir datos
      name = row["name"].to_s.force_encoding("ISO-8859-1").encode("UTF-8")
      description = row["Descripcion"].to_s.force_encoding("ISO-8859-1").encode("UTF-8")
      provider = row["Provider"]
      price = row["Price"].gsub(/[^\d.]/, '').to_f # Eliminar "$" y "," del precio
      cost = row["cost"].to_f
      available_quantity = row["available_quantity"].to_i
      code= row["code"]

      # Crear o actualizar el stock
      stock = Stock.find_or_initialize_by(name: name, provider: provider)
      stock.update!(
        description: description,
        price: price,
        cost: cost,
        available_quantity: available_quantity,
        code: code
      )
    end

    puts "✅ Stock importado correctamente"
  end
end