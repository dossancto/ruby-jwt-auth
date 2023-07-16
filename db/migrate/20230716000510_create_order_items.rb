class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items, id: :uuid do |t|
      t.string :order_id
      t.string :product_id
      t.integer :quantity
      t.decimal :price_per_unit, precision: 10, scale: 2, null: false
      t.decimal :subtotal, precision: 10, scale: 2, null: false
      t.timestamps
    end

    add_index :order_items, :id, unique: true
  end
end
