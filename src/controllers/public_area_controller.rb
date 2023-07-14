# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require_relative '../middlewares/user_middleware'

## AdminAreaController
class PublicAreaController < UserMiddleware
  set :views, File.expand_path('../views', __dir__)

  get '/' do
    erb :'public_area/index'
  end
end
