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

    return api_render_one(product) unless browser_request?

    if product.is_a?(Array)
      status 400
      flash[:error] = product.join(', ')
      redirect back
    end

    flash[:success] = 'Product Created!'
    status 201
    redirect "/product/#{product.id}"
  end

  get '/:id' do |id|
    @product = Product::Select.new.by_id(id)

    render! :show
  end
end
