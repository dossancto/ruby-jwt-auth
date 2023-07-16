# frozen_string_literal: true

## OrderModel
class OrderItemsModel
  attr_accessor :id, :product_id, :order_id, :quantity, :price_per_unit, :subtotal, :created_at, :updated_at

  def initialize(attributes = {})
    @id = attributes[:id]

    @product_id = attributes[:product_id]
    @order_id = attributes[:order_id]
    @quantity = attributes[:quantity]

    @price_per_unit = attributes[:price_per_unit]
    @subtotal = attributes[:subtotal]

    @created_at = attributes[:created_at]
    @updated_at = attributes[:updated_at]
  end
end
