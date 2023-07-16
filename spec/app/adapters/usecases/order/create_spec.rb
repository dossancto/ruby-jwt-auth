# frozen_string_literal: true

require './spec/spec_helper'

require './app/adapters/usecases/order/index'
require './app/adapters/usecases/user/index'

require './app/repositories/user_accounts_repository'
require './app/models/order_model'
require './app/repositories/order_repository'

RSpec.describe Order do
  let(:valid_order_infos) do
    {
      total_ammount: 50
    }
  end

  context 'Create a new order' do
    it 'New order' do
      some_user = User::Register.new(params: { user_name: 'JohnDoe', password: 'correctPassword',
                                               email: 'johndoe@example.com' }).call

      order = Order::Create.new(params: valid_order_infos).from_user(some_user).call

      expect(order.class).to be(OrderRepository)

      expect(order.user_id).to eq(some_user.id)
    end
  end
end
