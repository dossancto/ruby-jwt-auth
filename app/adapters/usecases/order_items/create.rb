# frozen_string_literal: true

require './app/models/order_items_models'
require './app/repositories/order_items_repository'

module OrderItems
  class Create
    def initialize(order_id:, product:, order_items_model: OrderItemsModel,
                   order_items_repository: OrderItemsRepository)
      @order_id = order_id
      @product = product
      @order_items_model = order_items_model
      @order_items_repository = order_items_repository
    end

    def with_quantity(quantity)
      @quantity = quantity
      self
    end

    def call
      return false unless can_buy?

      order_items = @order_items_model.new({})

      order_items.product_id = @product.id
      order_items.order_id = @order_id

      order_items.quantity = @quantity
      order_items.price_per_unit = @product.price
      order_items.subtotal = (@product.price * @quantity)

      @order_items_repository.create!(order_items.as_json)
    end

    def can_buy?
      (@product.stock_quantity - 10) > @quantity
    end
  end
end
