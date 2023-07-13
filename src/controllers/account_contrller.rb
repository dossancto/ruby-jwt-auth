# frozen_string_literal: true

require 'sinatra/base'
require_relative '../middlewares/user_middleware'
require_relative '../services/jwt_service'
require_relative '../services/bcrypt_service'
require_relative '../models/user_accounts'
require_relative '../repositories/user_accounts_repository'

## AdminAreaController
class AccountController < UserMiddleware
  set :views, File.expand_path('../views', __dir__)

  get '/account/log_in' do
    unnathenticate!

    erb :'accounts/index'
  end

  get '/account/register' do
    unnathenticate!

    erb :'accounts/register'
  end

  post '/account/register' do
    user = UserAccounts.new

    user.user_name = params[:user_name]
    user.password = BcryptService.encode_password(params[:password])
    user.email = params[:email]
    user.roles = ['admin', 'user']

    user.save

    token = JWTService.encode(user.as_json)

    set_jwt_cookie(token)

    status 201

    user_agent = request.user_agent

    return token unless user_agent =~ /Mozilla|Chrome|Safari|Opera|Firefox/

    redirect '/account/manage'
  end

  post '/account/log_in' do
    email = params[:email]
    password = params[:password]

    user = UserAccountsRepository.user_from_email_password(email, password)

    return redirect '/account/log_in' unless user

    token = JWTService.encode(user.as_json)

    set_jwt_cookie(token)

    status 200
    user_agent = request.user_agent

    return token unless user_agent =~ /Mozilla|Chrome|Safari|Opera|Firefox/

    redirect '/account/manage'
  end

  get '/account/confirm/:token' do
  end

  get '/account/manage' do
    authenticate!

    @user = @current_user
    erb :'accounts/manage'
  end

  def set_jwt_cookie(token)
    response.set_cookie(:jwt_token, {
                          value: token,
                          expires: Time.now + 3600,  # Expires in 1 hour
                          path: '/',                 # Cookie available for all routes
                          secure: true,              # Only send the cookie over HTTPS
                          http_only: true            # Restrict cookie access to HTTP requests only
                        })
  end
end
