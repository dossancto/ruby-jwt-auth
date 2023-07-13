# frozen_string_literal: true

require 'sinatra/base'
require_relative '../middlewares/user_middleware'
require_relative '../services/jwt_service'
require_relative '../services/bcrypt_service'

## AdminAreaController
class AccountController < UserMiddleware
  set :views, File.expand_path('../views', __dir__)

  get '/account/log_in' do
    unnathenticate!

    erb :'accounts/index'
  end

  post '/account/log_in' do
    @user = {
      user_id: 2,
      user_name: params[:user_name],
      email: params[:email],
      password: BcryptService.encode_password(params[:password]),
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
    user_agent = request.user_agent

    return token unless user_agent =~ /Mozilla|Chrome|Safari|Opera|Firefox/

    redirect '/account/manage'
  end

  get '/account/manage' do
    authenticate!

    @user = @current_user
    puts @current_user
    erb :'accounts/manage'
  end
end
