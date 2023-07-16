# frozen_string_literal: true

require './spec/spec_helper'

require './app/adapters/usecases/order_items/index'
require './app/adapters/usecases/order/index'
require './app/adapters/usecases/user/index'
require './app/adapters/usecases/product/index'

require './app/repositories/user_accounts_repository'
require './app/models/order_model'
require './app/repositories/order_repository'

RSpec.describe OrderItems::Create do
  let(:valid_order_items_infos) do
    { quantity: 10 }
  end

  let(:user) do
    User::Register.new(params: { user_name: 'JohnDoe', password: 'correctPassword',
                                 email: 'johndoe@example.com' }).call
  end

  let(:order) do
    Order::Create.new.from_user(user).call
  end

  let(:product) do
    Product::Create.new(params: {
                          name: 'Cafeteria',
                          description: 'Faz cafe e muito mais coisas',
                          category: 'eletronic',
                          price: 122.5,
                          stock_quantity: 50
                        }).call
  end

  context 'Create a new order' do
    it 'New order' do
      order_item = OrderItems::Create.new(order_id: order.id, product:).with_quantity(10).call

      expect(order_item.class).to be(OrderItemsRepository)
      expect(order_item.product_id).to eq(product.id)
      expect(order_item.order_id).to eq(order.id)
    end
  end
end
