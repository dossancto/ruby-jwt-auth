# frozen_string_literal: true

require 'sinatra/base'
require_relative '../middlewares/user_middleware'
require_relative '../services/jwt_service'

## AdminAreaController
class AccountController < Sinatra::Base
  set :views, File.expand_path('../views', __dir__)

  get '/account/log_in' do
    # unnathenticate!

    # 'Pleace log in'
    erb :'accounts/index'
  end

  post '/account/log_in' do
    @user = {
      user_id: 2,
      user_name: params[:user_name],
      email: params[:email],
      password: params[:password],
      roles: %i[user]
    }

    token = JWTService.encode @user

    response.set_cookie(:jwt_token, {
                          value: token,
                          expires: Time.now + 3600,  # Expires in 1 hour
                          path: '/',                 # Cookie available for all routes
                          secure: true,              # Only send the cookie over HTTPS
                          http_only: true            # Restrict cookie access to HTTP requests only
                        })

    redirect '/admin'
  end
end
