# frozen_string_literal: true

require './app/models/product_model'
require './app/repositories/product_repository'
require './app/adapters/validation/product/index'

module Product
  class Avaibility
    def initialize(product_id:, product_model: ProductModel, product_repository: ProductRepository)
      @product_id = product_id
      @product_model = product_model
      @product_repository = product_repository
    end

    def disable
      change_active(false)
    end

    def active
      change_active(true)
    end

    private

    def change_active(avaible)
      product = Product::Select.new.with_adm.by_id(@product_id)
      @product_repository.update(product.id, { avaible: })
    end
  end
end
