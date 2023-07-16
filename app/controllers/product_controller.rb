# frozen_string_literal: true

require './app/adapters/usecases/product/index'

## AdminAreaController
class ProductController < ApplicationController
  get '/' do
    admin = @current_user&.access?(roles: [:admin])
    @products = Product::Select.new.with_adm(adm: admin).all

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

  get '/edit/:id' do |id|
    authenticate!
    authorize! [:admin]

    @product = Product::Select.new.with_adm.by_id(id)
    render! :edit
  end

  post '/edit/:id' do |id|
    authenticate!
    authorize! [:admin]

    product = Product::Update.new(product_id: id, params:).call

    return api_render_one(product) unless browser_request?

    if product.is_a?(Array)
      status 400
      flash[:error] = product.join(', ')
      redirect back
    end

    flash[:success] = 'Product Updated'
    status 201
    redirect "/product/#{product.id}"
  end

  post '/disable' do
    id = params[:id]
    @product = Product::Avaibility.new(product_id: id).disable

    return api_render_one(product) unless browser_request?

    if !@product || @product.avaible != false
      status 400
      flash[:error] = "Fail to disable product #{@product.name}"
      redirect back
    end

    status 201 # TODO: Change to correct http status code for update
    flash[:success] = 'Product disabled'
    redirect "/product/#{id}"
  end

  post '/active' do
    id = params[:id]
    @product = Product::Avaibility.new(product_id: id).active

    return api_render_one(product) unless browser_request?

    if @product&.avaible
      status 201 # TODO: Change to correct http status code for update
      flash[:success] = 'Product actived'
      redirect "/product/#{id}"
    end

    status 400
    flash[:error] = "Fail to active \"#{@product.name}\""
    redirect back
  end

  get '/:id' do |id|
    admin = @current_user&.access?(roles: [:admin])
    @product = Product::Select.new.with_adm(adm: admin).by_id(id)

    return render! :show if @product

    flash[:error] = 'Product not found'

    redirect '/product'
  end
end
