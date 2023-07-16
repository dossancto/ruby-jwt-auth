# frozen_string_literal: true

require './app/models/product_model'
require './app/repositories/product_repository'

module Product
  class ReduceStock
    def initialize(order:, product_model: ProductModel, product_repository: ProductRepository)
      @order = order
      @quantity = @order.quantity

      @product_model = product_model
      @product_repository = product_repository
    end

    def call
      @product = @product_repository.find_by(id: @order.product_id)

      return false unless can_buy?

      new_stock = @product.stock_quantity - @quantity
      @product_repository.update(@product.id, { stock_quantity: new_stock })

      @product
    end

    def can_buy?
      (@product.stock_quantity - 10) > @quantity
    end
  end
end
