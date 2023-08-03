class BulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bulk_discounts do |t|
      t.integer :merchant_id
      t.integer :perentage_discount
      t.integer :quantity_threshold
      t.timestamps
    end
  end
end
