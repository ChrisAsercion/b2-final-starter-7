require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    #US 6
    it "revenue discounted" do
      @merchant1 = Merchant.create!(name: 'Hair Care')

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      @bulk_discount1 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 20, quantity_threshold: 10, tag: "20% off")
      @bulk_discount2 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 10, quantity_threshold: 5, tag: "10% off")
      @bulk_discount3 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 50, quantity_threshold: 40, tag: "50% off")

      expect(@invoice_1.revenue_discounted).to eq(91)
    end



    it "does more complex revenue_discounts" do
      @merchant1 = Merchant.create!(name: 'Hair Care')

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 5, unit_price: 20, status: 1)
      @ii_111 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 50, unit_price: 10, status: 1)

      @bulk_discount1 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 20, quantity_threshold: 10, tag: "20% off")
      @bulk_discount2 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 10, quantity_threshold: 5, tag: "10% off")
      @bulk_discount3 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 50, quantity_threshold: 40, tag: "50% off")

      expect(@invoice_1.revenue_discounted).to eq(420)
    end

    describe "Bulk Discount examples" do
      it "#Example 1" do
        @merchant1 = Merchant.create!(name: 'Hair Care')

        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)

        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 10, status: 1)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 20, status: 1)

        @bulk_discount1 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 20, quantity_threshold: 10, tag: "20% off")

        #No discount was applied to this invoice (5x10 + 5x20 = 150)
        expect(@invoice_1.revenue_discounted).to eq(150)
      end

      it "#Example 2" do
        @merchant1 = Merchant.create!(name: 'Hair Care')

        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)

        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 1)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 10, status: 1)

        @bulk_discount1 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 20, quantity_threshold: 10, tag: "20% off")

        #1 discount was applied to this invoice ((10x10)*.8 + 5x10 = 130)
        expect(@invoice_1.revenue_discounted).to eq(130)
      end

      it "#Example 3" do
        @merchant1 = Merchant.create!(name: 'Hair Care')

        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)

        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 1)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 15, unit_price: 10, status: 1)

        @bulk_discount1 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 20, quantity_threshold: 10, tag: "20% off")
        @bulk_discount2 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 30, quantity_threshold: 15, tag: "30% off")

        #2 discounts were applied to this invoice ((12x10)*.8 + (15x10)*.7 = 201)
        expect(@invoice_1.revenue_discounted).to eq(201)
      end

      it "#Example 4" do
        @merchant1 = Merchant.create!(name: 'Hair Care')

        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)

        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 1)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 15, unit_price: 10, status: 1)

        @bulk_discount1 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 20, quantity_threshold: 10, tag: "20% off")
        @bulk_discount2 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 15, quantity_threshold: 15, tag: "15% off")

        #1 discount was applied to both, bulk discount 2 is never applied. ((12x10)*.8 + (15x10)*.8 = 216)
        expect(@invoice_1.revenue_discounted).to eq(216)
      end

      it "#Example 5" do
        @merchantA = Merchant.create!(name: 'Hair Care')
        @merchantB = Merchant.create!(name: 'Sports Equipment')

        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchantA.id, status: 1)
        @item_2 = Item.create!(name: "Football", description: "You kick it, don't throw it", unit_price: 10, merchant_id: @merchantB.id, status: 1)

        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')

        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")

        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 1)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 15, unit_price: 10, status: 1)
        @ii_111 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 15, unit_price: 10, status: 1)

        @bulk_discount1 = BulkDiscount.create!(merchant_id: @merchantA.id, percentage_discount: 20, quantity_threshold: 10, tag: "20% off")
        @bulk_discount2 = BulkDiscount.create!(merchant_id: @merchantA.id, percentage_discount: 30, quantity_threshold: 15, tag: "30% off")

        #II 1 should receive bulk discount 1, II 2 should receive bulk discount 2. ((12x10)*.8 + (15x10)*.7 = 201)
        expect(@invoice_1.revenue_discounted).to eq(201)

        #II 3 is tied to merchantB who does not have a bulk discount. This should be an undiscounted revenue. (15x10 = 150)
        expect(@invoice_2.revenue_discounted).to eq(150)

      end
    end


    #US7
    describe "#discount_finder" do
      it "Orders all the invoice_items an invoice has, then ascertains the discount that will be applied to the invoice_item with the method 'discount' " do
        @merchant1 = Merchant.create!(name: 'Hair Care')

        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
  
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
  
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
  
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 5, unit_price: 10, status: 1)
  
        @bulk_discount1 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 20, quantity_threshold: 10, tag: "20% off")
        @bulk_discount2 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 10, quantity_threshold: 5, tag: "10% off")
        @bulk_discount3 = BulkDiscount.create!(merchant_id: @merchant1.id, percentage_discount: 50, quantity_threshold: 40, tag: "50% off")
  
        
      invoice_discounts = @invoice_1.discount_finder

      expect(invoice_discounts.first.discount).to eq(@bulk_discount1.id)
      expect(invoice_discounts.second.discount).to eq(@bulk_discount2.id)
      end
    end

  end
end
