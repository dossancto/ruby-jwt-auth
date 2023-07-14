# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/activerecord'
require 'sinatra/contrib'
require './app/controllers/admin_area_controller'
require './app/controllers/public_area_controller'
require './app/controllers/account_contrller'
require './app/middlewares/user_middleware'

## MyApp
class MyApp < UserMiddleware
  use AdminAreaController
  use AccountController
  use PublicAreaController

  configure do
    enable :sessions
    set :views, File.join(File.dirname(__FILE__), '/app/views')
    set :database_file, 'config/database.yml'
    set :public_folder, File.join(File.dirname(__FILE__), '/public')
    register Sinatra::Flash
  end

  get '/gen-token' do
    user = { user_id: 1, user_name: 'test', password: 'deus-da-morte', roles: %i[admin user] }
    token = JWTService.encode user

    response.set_cookie(:jwt_token, {
                          value: token,
                          expires: Time.now + 3600,  # Expires in 1 hour
                          path: '/',                 # Cookie available for all routes
                          secure: true,              # Only send the cookie over HTTPS
                          http_only: true            # Restrict cookie access to HTTP requests only
                        })

    'sucess'
  end

  set :views, File.join(File.dirname(__FILE__), '/app/views')
end
