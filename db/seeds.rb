# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Création d'un utilisateur admin par défaut
admin_address = Address.create!(
  zip: '75000',
  town: 'Paris',
  street: 'Rue de l\'Administration',
  number: '1'
)

admin = Person.create!(
  email: 'admin@admin.admin',
  password: '123456',
  username: 'admin',
  firstname: 'Admin',
  lastname: 'System',
  phone_number: '0123456789',
  role: 'admin',
  address: admin_address
)

puts 'Admin user created successfully!'
puts 'Email: admin@example.com'
puts 'Password: password123'
