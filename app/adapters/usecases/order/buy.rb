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

      a = @products.map do |json|
        product = json[:product]
        quantity = json[:quantity]

        item = OrderItems::Create.new(order_id: order.id, product:).with_quantity(quantity).call
        p = Product::ReduceStock.new(order: item).call

        puts item.as_json
        puts p.as_json
        p
      end

      order.total_ammount = a.size
      require 'byebug'
      byebug
      order.save

      order
    end
  end
end
