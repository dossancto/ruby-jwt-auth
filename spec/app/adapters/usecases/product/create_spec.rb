# frozen_string_literal: true

require './spec/spec_helper'

require './app/adapters/usecases/product/index'
require './app/models/product_model'
require './app/repositories/product_repository'

RSpec.describe Product do
  let(:valid_product_infos) do
    {
      name: 'Cafeteria',
      description: 'Faz cafe',
      price: 122.5,
      stock_quantity: 5
    }
  end

  context 'With new product' do
    it 'New product created' do
      product = Product::Create.new(params: valid_product_infos).call

      expect(product.class).to be(ProductRepository)

      expect(ProductRepository.last.id).to eq(product.id)
    end
  end
end
