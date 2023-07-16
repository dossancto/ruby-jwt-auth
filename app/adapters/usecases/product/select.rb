# frozen_string_literal: true

require './app/models/product_model'
require './app/repositories/product_repository'

module Product
  class Select
    def initialize(product_repository: ProductRepository)
      @product_repository = product_repository
    end

    def by_id(id)
      @product_repository.find_by(id:)
    end

    def all
      @product_repository.all
    end
  end
end
