# frozen_string_literal: true

require './app/models/order_model'
require './app/repositories/order_repository'

module Order
  class Create
    def initialize(order_model: OrderModel, order_repository: OrderRepository)
      @order_model = order_model
      @order_repository = order_repository
    end

    def from_user(user)
      @user = user
      self
    end

    def call
      order = @order_model.new({})
      order.user_id = @user.id
      order.total_ammount = 0
      order.state ||= 'pending'

      @order_repository.create!(order.as_json)
    end
  end
end
