# frozen_string_literal: true

require './app/adapters/usecases/order_items/index'
require './app/adapters/usecases/product/index'

module Order
  ## Buy
  class Buy
    def initialize(user:, products:)
      @user = user
      @products = products
    end

    def call
      order = Order::Create.new.from_user(@user).call

      prods = @products.map do |json|
        product = json[:product]
        quantity = json[:quantity]

        item = OrderItems::Create.new(order_id: order.id, product:).with_quantity(quantity).call
        Product::ReduceStock.new(order: item).call
      end

      order.total_ammount = prods.size
      order.save

      order
    end
  end
end
