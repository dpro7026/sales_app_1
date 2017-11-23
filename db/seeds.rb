# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
if Rails.env.development?
    # Create a default admin
    AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
    # Create a default user
    User.create!(email: 'harry@example.com', first_name: 'Harry', last_name: 'Potter', password: 'password', password_confirmation: 'password')
    # Create default products
    Product.create!(price: 9.99).book!
    Product.new(price: 19990).car!
    Product.new(price: 99.99).software!
    #Product.create!(category: 0, price: 9.99) is the same as Product.create!(price: 9.99).book!
    # We prefer to use the enum method for modifying/creating for readability
end
