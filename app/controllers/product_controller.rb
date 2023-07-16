# frozen_string_literal: true

require './app/adapters/usecases/product/index'

## AdminAreaController
class ProductController < ApplicationController
  get '/' do
    @products = Product::Select.new.all
    render! :index
  end

  get '/new-product' do
    authenticate!
    authorize! [:admin]

    render! :add_product
  end

  post '/new-product' do
    authenticate!
    authorize! [:admin]

    puts params

    product = Product::Create.new(params:).call

    product.to_json
  end
end
