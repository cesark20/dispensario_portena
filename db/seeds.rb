# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Borrar todos los usuarios antes de poblar la base de datos (opcional, solo si quieres empezar de cero)
User.destroy_all

# Crear usuarios con diferentes roles
users = [
  { name: "Cliente", email: "cliente@example.com", password: "cliente", role: :client },
  { name: "Empleado", email: "empleado@example.com", password: "empleado", role: :employee },
  { name: "Vendedor", email: "vendedor@example.com", password: "vendedor", role: :seller },
  { name: "Admin", email: "admin@example.com", password: "password", role: :admin },
  { name: "Super Admin", email: "superadmin@example.com", password: "password", role: :superadmin }
]

users.each do |user_attrs|
  User.create!(user_attrs)
end

puts "Se crearon #{User.count} usuarios con distintos roles."