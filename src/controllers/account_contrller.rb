# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require_relative '../middlewares/user_middleware'

require_relative '../services/jwt_service'
require_relative '../services/bcrypt_service'
require_relative '../services/email_service'

require_relative '../models/user_accounts'

require_relative '../repositories/user_accounts_repository'
require_relative '../repositories/user_accounts_email_tokens_repository'

## AdminAreaController
class AccountController < UserMiddleware
  set :views, File.expand_path('../views', __dir__)

  get '/account/log_in' do
    puts @current_user
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
    user.roles = %w[admin user]

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

    flash[:success] = 'Login successful!'
    redirect '/account/manage'
  end

  get '/account/confirm/:code' do |code|
    email = UserAccountsEmailTokensRepository.email_tokem_from_code(code)
    user = UserAccountsRepository.user_by_id(email.user_id)

    return 'Code expired' if Time.now.utc >= email.valid_for
    return 'invalid code' unless UserAccountsRepository.confirm_email(user)

    UserAccountsEmailTokensRepository.destroy_code(user)
    flash[:success] = 'Email confirmed!'

    redirect '/'
  end

  get '/account/manage' do
    authenticate!

    erb :'accounts/manage'
  end

  get '/account/verify-email' do
    email_unverified!

    return redirect '/account/log_in' unless @current_user
    return redirect '/' if @current_user.email_confirmed

    email = UserAccountsEmailTokensRepository.token_from_user(@current_user)

    return redirect '/account/email-verify' if email

    email_code = UserAccountsEmailTokensRepository.new_email_token(@current_user)

    EmailService.send_confirmation_email(@current_user, email_code)

    flash[:success] = 'Email sended to your email.'
    redirect '/account/email-verify'
  end

  get '/account/email-verify' do
    email_unverified!

    erb :'accounts/verify_email'
  end

  get '/account/regenerate-email-code/' do
    return redirect '/account/log_in' unless @current_user
    return redirect '/' if @current_user.email_confirmed

    UserAccountsEmailTokensRepository.destroy_code(@current_user)

    redirect '/account/verify-email'
  end

  get '/account/reset-password' do
    authenticate!

    erb :'accounts/reset_password'
  end

  get '/account/log_out' do
    response.set_cookie(:jwt_token, {
                          value: nil,
                          expires: Time.now + 3600,  # Expires in 1 hour
                          path: '/',                 # Cookie available for all routes
                          secure: true,              # Only send the cookie over HTTPS
                          http_only: true            # Restrict cookie access to HTTP requests only
                        })

    flash[:error] = 'Unlogged'
    redirect '/'
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
