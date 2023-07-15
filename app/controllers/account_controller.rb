# frozen_string_literal: true

require './app/controllers/application_controller'

require './app/services/jwt_service'
require './app/services/bcrypt_service'
require './app/services/email_service'

require './app/repositories/user_accounts_repository'
require './app/repositories/user_accounts_email_tokens_repository'

## AdminAreaController
class AccountController < ApplicationController
  include CookieHelper

  get '/log_in' do
    unnathenticate!

    render! :index
  end

  get '/register' do
    unnathenticate!

    render! :register
  end

  post '/register' do
    user = UserAccountsRepository.new_from_params(params)

    unless user 
      flash[:error] = "Pleace check the fields and try again"
      redirect '/register'
    end

    token = JWTService.encode(user.as_json)

    set_jwt_token(token)

    status 201

    user_agent = request.user_agent

    return token unless user_agent =~ /Mozilla|Chrome|Safari|Opera|Firefox/

    redirect '/account/manage'
  end

  post '/log_in' do
    email = params[:email]
    password = params[:password]

    user = UserAccountsRepository.user_from_email_password(email, password)

    unless user
      flash[:error] = 'Email or password does not exist'
      redirect '/account/log_in'
    end

    token = JWTService.encode(user.as_json)

    set_jwt_token(token)

    status 200
    user_agent = request.user_agent

    return token unless user_agent =~ /Mozilla|Chrome|Safari|Opera|Firefox/

    flash[:success] = 'Login successful!'
    redirect '/account/manage'
  end

  get '/confirm/:code' do |code|
    email = UserAccountsEmailTokensRepository.email_tokem_from_code(code)
    user = UserAccountsRepository.user_by_id(email.user_id)

    return 'Code expired' if Time.now.utc >= email.valid_for
    return 'invalid code' unless UserAccountsRepository.confirm_email(user)

    UserAccountsEmailTokensRepository.destroy_code(user)
    flash[:success] = 'Email confirmed!'

    redirect '/'
  end

  get '/manage' do
    authenticate!

    render! :manage
  end

  get '/verify-email' do
    email_unverified!

    return redirect '/account/log_in' unless @current_user
    return redirect '/' if @current_user.email_confirmed

    email = UserAccountsEmailTokensRepository.token_from_user(@current_user)

    return redirect '/account/email-verify' if email

    email_code = UserAccountsEmailTokensRepository.new_email_token(@current_user)

    begin
      EmailService.send_confirmation_email(@current_user, email_code)
    rescue StandardError
      flash[:error] = 'Error while sending email, place try again later'
      return redirect '/account/email-verify'
    end

    flash[:success] = 'Email sended to your email.'
    redirect '/account/email-verify'
  end

  get '/email-verify' do
    email_unverified!

    render! :verify_email
  end

  get '/regenerate-email-code/' do
    return redirect '/account/log_in' unless @current_user
    return redirect '/' if @current_user.email_confirmed

    UserAccountsEmailTokensRepository.destroy_code(@current_user)

    redirect '/account/verify-email'
  end

  get '/reset-password' do
    authenticate!

    render! :reset_password
  end

  get '/log_out' do
    invalidate_jwt_token!

    flash[:error] = 'Unlogged'
    redirect '/'
  end
end
