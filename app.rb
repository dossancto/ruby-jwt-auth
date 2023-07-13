# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/contrib'
require './src/controllers/admin_area_controller'
require './src/controllers/public_area_controller'
require './src/controllers/account_contrller'

## MyApp
class MyApp < Sinatra::Base
  configure do
    enable :sessions
    set :views, File.join(File.dirname(__FILE__), '/src/views')
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

  use AdminAreaController
  use AccountController
  use PublicAreaController
end
