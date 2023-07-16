# frozen_string_literal: true

require './app/models/order_items_models'
require './app/repositories/order_items_repository'

module OrderItems
  class Select
    def initialize(order_items_repository: OrderItemsRepository)
      @order_items_repository = order_items_repository
    end

    def from_order(order_id)
      @order_items_repository.where(order_id:).all
    end
  end
end
