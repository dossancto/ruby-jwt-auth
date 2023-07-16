# frozen_string_literal: true

require './spec/spec_helper'

require './app/adapters/usecases/order/index'
require './app/adapters/usecases/user/index'
require './app/adapters/usecases/product/index'

require './app/repositories/user_accounts_repository'
require './app/models/order_model'
require './app/repositories/order_repository'

RSpec.describe Order do
  let(:user) do
    User::Register.new(params: { user_name: 'JohnDoe', password: 'correctPassword',
                                 email: 'johndoe@example.com' }).call
  end

  let(:products) do
    [
      Product::Create.new(params: {
                            name: 'Cafeteria',
                            description: 'Faz cafe',
                            price: 122.5,
                            stock_quantity: 50
                          }).call
    ]
  end

  context 'Buy products' do
    it 'new buy' do
      order = Order::Buy.new(user:, products: [{ product: products[0], quantity: 10 }]).call
      orders = OrderItems::Select.new.from_order(order.id)

      expect(orders.size).to eq(1)
      expect(orders.size).to eq(order.total_ammount)

      product = Product::Select.new.by_id(orders[0].product_id)

      expect(product.stock_quantity).to be(products[0][:stock_quantity] - 10)
    end
  end
end
