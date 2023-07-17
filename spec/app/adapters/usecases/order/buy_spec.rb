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
                            description: 'Faz cafe e muito mais coisas',
                            price: 122.5,
                            category: 'eletronic',
                            stock_quantity: 50
                          }).call,
      Product::Create.new(params: {
                            name: 'Energético',
                            description: 'Café de dev nutella',
                            price: 500.12,
                            category: 'eletronic',
                            stock_quantity: 15
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

  context 'Fail to buy products' do
    it 'Insuficient products' do
      order = Order::Buy.new(user:, products: [{ product: products[0], quantity: 100 }])

      expect { order.call }.to raise_error(StandardError, "Only 40 items avaible for '#{products[0].name}'")
    end

    it 'Product out of stock' do
      # Clear the stock
      Order::Buy.new(user:, products: [{ product: products[0], quantity: 40 }]).call

      order = Order::Buy.new(user:, products: [{ product: products[0], quantity: 10 }])

      expect { order.call }.to raise_error(StandardError, "Product '#{products[0].name}' out of stock")
    end
  end
end
