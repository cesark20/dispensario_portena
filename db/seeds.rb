# db/seeds.rb

User.destroy_all

users = [
  {
    first_name: "Admin", last_name: "Admin", phone: "3512056440", address: "Calle 1",
    document_id: "123123123", email: "admin@example.com", password: "changeme",
    role: :admin, status: true
  },
  {
    first_name: "Farmacia", last_name: "Farmacia", phone: "3512056440", address: "Calle 1",
    document_id: "1231231231", email: "farmacia@example.com", password: "changeme",
    role: :pharmacy, status: true
  },
  {
    first_name: "Personal de la Salud", last_name: "Personal de la Salud", phone: "3512056440", address: "Calle 1",
    document_id: "12312312312", email: "personal_salud@example.com", password: "changeme",
    role: :healthcare_staff, status: true
  },
  {
    first_name: "Paciente", last_name: "Paciente", phone: "3512056440", address: "Calle 1",
    document_id: "1231231231232", email: "paciente@example.com", password: "changeme",
    role: :patient, status: true
  },
  {
    first_name: "Superadmin", last_name: "Superadmin", phone: "3512056440", address: "Calle 1",
    document_id: "12312312", email: "superadmin@example.com", password: "changeme",
    role: :admin, status: true
  }
]

users.each do |attrs|
  user = User.find_or_initialize_by(email: attrs[:email])
  user.update!(attrs)
end

puts "Se crearon/actualizaron #{User.count} usuarios."


Provider.destroy_all

providers = [
  { name: "Distribuidora Farma SA", contact_name: "Carlos Pérez", phone: "3512001111", email: "contacto@farma.com", address: "Av. Siempre Viva 123", cuit: "30-12345678-9", status: true },
  { name: "Laboratorio Vida", contact_name: "María López", phone: "3512002222", email: "ventas@vidalab.com", address: "Bv. San Juan 456", cuit: "30-98765432-1", status: true },
  { name: "Proveedora Salud SRL", contact_name: "Jorge Gómez", phone: "3512003333", email: "info@proveesalud.com", address: "Colón 789", cuit: "30-11223344-5", status: false }
]

Provider.create!(providers)
puts "Se cargaron #{Provider.count} proveedores"