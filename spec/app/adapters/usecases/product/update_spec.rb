# frozen_string_literal: true

require './spec/spec_helper'

require './app/adapters/usecases/product/index'
require './app/models/product_model'
require './app/repositories/product_repository'

RSpec.describe Product do
  let(:valid_product_infos) do
    {
      name: 'Cafeteria',
      description: 'Faz cafe e muito mais coisas',
      category: 'eletronic',
      price: 122.5,
      stock_quantity: 5
    }
  end

  let(:new_infos) do
    {
      name: 'A feira do ovo',
      description: 'Faz cafe e muito mais coisas',
      category: 'eletronic',
      price: 122.5,
      stock_quantity: 5
    }
  end

  context 'With update product' do
    it 'Update with valid fields' do
      product = Product::Create.new(params: valid_product_infos).call
      updated_product = Product::Update.new(product_id: product.id, params: new_infos).call

      expect(updated_product.class).to be(ProductRepository)

      expect(updated_product.id).to eq(product.id)
      expect(updated_product.name).to eq('A feira do ovo')
    end
  end
end
