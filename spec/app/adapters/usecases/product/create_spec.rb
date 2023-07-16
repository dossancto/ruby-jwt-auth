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

  let(:blank_product_infos) do
    {
      name: '',
      description: '',
      category: '',
      price: '',
      stock_quantity: ''
    }
  end

  let(:empty_product_infos) do
    {}
  end

  let(:half_empty_product_infos) do
    {
      price: 122.5,
      stock_quantity: 5
    }
  end

  let(:invalid_numbers_product_infos) do
    {
      name: 'Cafeteria',
      description: 'Faz cafe e muito mais coisas',
      category: 'eletronic',
      price: '20.2a4',
      stock_quantity: -1
    }
  end

  let(:invalid_text_product_infos) do
    {
      name: 'sort',
      description: 'So short',
      category: 'eletronic',
      price: 122.5,
      stock_quantity: 5
    }
  end

  context 'With new product' do
    it 'New product created' do
      product = Product::Create.new(params: valid_product_infos).call

      expect(product.class).to be(ProductRepository)
    end
  end

  context 'With new invalid product infos' do
    it 'empty product' do
      product = Product::Create.new(params: empty_product_infos).call

      expect(product.class).to be(Array)
      expect(product.size).to eq(5)
    end

    it 'without 3 fields' do
      product = Product::Create.new(params: half_empty_product_infos).call

      expect(product.class).to be(Array)
      expect(product.size).to eq(3)
    end

    it 'Wrong types' do
      puts 'wong type'
      product = Product::Create.new(params: invalid_numbers_product_infos).call

      expect(product.class).to be(Array)
      expect(product.size).to eq(1)
    end

    it 'Invalid texts' do
      product = Product::Create.new(params: invalid_text_product_infos).call

      expect(product.class).to be(Array)
      expect(product.size).to eq(2)
    end

    it 'Blank params' do
      product = Product::Create.new(params: blank_product_infos).call

      expect(product.class).to be(Array)
      expect(product.size).to eq(5)
    end
  end
end
