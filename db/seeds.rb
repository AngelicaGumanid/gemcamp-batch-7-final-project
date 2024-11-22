# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "Creating users..."
admin = User.create!(email: 'adminpass@email.com', password: 'adminsecurepass', genre: 'admin', username: 'AdminUser')
client = User.create!(email: 'user1@email.com', password: 'qwerty123', genre: 'client', username: 'ClientUser')

puts "Users created: #{User.pluck(:email).join(', ')}"

# Create Categories
puts "Creating categories..."
categories_data = [
  { name: 'Phone' },
  { name: 'TV' },
  { name: 'Perfume' },
  { name: 'Electronics' }
]
Category.create!(categories_data)

# Fetch created categories
phone_category = Category.find_by(name: 'Phone')
tv_category = Category.find_by(name: 'TV')
perfume_category = Category.find_by(name: 'Perfume')
electronics_category = Category.find_by(name: 'Electronics')

puts "Categories created: #{Category.pluck(:name).join(', ')}"

# Validate that categories were created
raise "Category 'Phone' not found!" if phone_category.nil?
raise "Category 'TV' not found!" if tv_category.nil?
raise "Category 'Perfume' not found!" if perfume_category.nil?
raise "Category 'Electronics' not found!" if electronics_category.nil?