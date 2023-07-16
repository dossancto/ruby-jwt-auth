# frozen_string_literal: true

require './app/models/product_model'
require './app/repositories/product_repository'
require './app/adapters/validation/product/index'

module Product
  class Create
    def initialize(params:, product_model: ProductModel, product_repository: ProductRepository)
      @params = params
      @product_model = product_model
      @product_repository = product_repository
    end

    def call
      err_msg = ProductValidation::Create.new(params: @params).call
      return err_msg unless err_msg.empty?

      product = @product_model.new(@params)

      @product_repository.create!(product.as_json)
    end
  end
end
