# frozen_string_literal: true

require './app/models/product_model'
require './app/repositories/product_repository'

module Product
  class Create
    def initialize(params:, product_model: ProductModel, product_repository: ProductRepository)
      @params = params
      @product_model = product_model
      @product_repository = product_repository
    end

    def call
      product = @product_model.new(@params)

      @product_repository.create!(product.as_json)
    end
  end
end
