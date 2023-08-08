# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Customer.destroy_all
Item.destroy_all
Invoice.destroy_all
InvoiceItem.destroy_all
Merchant.destroy_all
Transaction.destroy_all
#Rake::Task["csv_load:all"].invoke

@customer_1 = Customer.create!(first_name: "Joey", last_name: "Ondricka")
  @customer_2 = Customer.create!(first_name: "Cecelia", last_name: "Osinski")
  @customer_3 = Customer.create!(first_name: "Mariah", last_name: "Toy")
  @customer_4 = Customer.create!(first_name: "Tom", last_name: "Tomson")
  @customer_5 = Customer.create!(first_name: "Joan", last_name: "Jones")
  @customer_6 = Customer.create!(first_name: "Steve", last_name: "Steves")

  @merchant_1 = Merchant.create!(name: "Schroeder-Jerde")
  @merchant_2 = Merchant.create!(name: "Klein, Rempel and Jones")
  @merchant_3 = Merchant.create!(name: "Willms and Sons")
  
  @invoice_1 = @customer_1.invoices.create!(customer_id: @customer_1.id, status: 2)
  @invoice_2 = @customer_2.invoices.create!(customer_id: @customer_2.id, status: 1)
  @invoice_3 = @customer_3.invoices.create!(customer_id: @customer_3.id, status: 2)
  @invoice_4 = @customer_4.invoices.create!(customer_id: @customer_4.id, status: 2)
  @invoice_5 = @customer_5.invoices.create!(customer_id: @customer_5.id, status: 2)
  @invoice_6 = @customer_6.invoices.create!(customer_id: @customer_6.id, status: 2)
  @invoice_7 = @customer_1.invoices.create!(customer_id: @customer_1.id, status: 2)
  @invoice_8 = @customer_2.invoices.create!(customer_id: @customer_2.id, status: 1)
  @invoice_9 = @customer_3.invoices.create!(customer_id: @customer_3.id, status: 2)
  @invoice_10 = @customer_4.invoices.create!(customer_id: @customer_4.id, status: 2)
  @invoice_11 = @customer_5.invoices.create!(customer_id: @customer_5.id, status: 2)

  @invoice_12 = @customer_1.invoices.create!(customer_id: @customer_1.id, status: 0)
  @invoice_13 = @customer_1.invoices.create!(customer_id: @customer_1.id, status: 0)
  @invoice_14 = @customer_2.invoices.create!(customer_id: @customer_2.id, status: 0)

  @bulk_discount1 = BulkDiscount.create!(merchant_id: @merchant_1.id, percentage_discount: 20, quantity_threshold: 10, tag: "20% off")
  @bulk_discount2 = BulkDiscount.create!(merchant_id: @merchant_1.id, percentage_discount: 10, quantity_threshold: 5, tag: "10% off")
  @bulk_discount3 = BulkDiscount.create!(merchant_id: @merchant_1.id, percentage_discount: 50, quantity_threshold: 40, tag: "50% off")