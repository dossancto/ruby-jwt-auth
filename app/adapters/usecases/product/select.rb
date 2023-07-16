# frozen_string_literal: true

require './app/models/product_model'
require './app/repositories/product_repository'

module Product
  class Select
    def initialize(product_repository: ProductRepository)
      @product_repository = product_repository
      @is_adm = false
    end

    def with_adm(adm: true)
      @is_adm = adm
      self
    end

    def by_id(id)
      return @product_repository.find_by(id:) if @is_adm

      @product_repository.where(avaible: true).find_by(id:)
    end

    def all
      return @product_repository.all if @is_adm

      @product_repository.where(avaible: true).all
    end
  end
end
