# frozen_string_literal: true

require './app/models/product_model'
require './app/repositories/product_repository'
require './app/adapters/validation/product/index'

module Product
  class Disable
    def initialize(product_id:, product_model: ProductModel, product_repository: ProductRepository)
      @product_id = product_id
      @product_model = product_model
      @product_repository = product_repository
    end

    def call
      product = Product::Select.new.with_adm.by_id(@product_id)
      @product_repository.update(product.id, { avaible: false })

      product
    end
  end
end
