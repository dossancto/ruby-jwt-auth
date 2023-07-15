# frozen_string_literal: true

require './app/controllers/application_controller'

require './app/services/jwt_service'
require './app/services/email_service'

require './app/adapters/usecases/user/index'

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
    user = User::Register.new(params:).call

    unless user
      flash[:error] = 'Pleace check the fields and try again'
      redirect '/register'
    end

    token = JWTService.encode(user.as_json)

    set_jwt_token(token)

    status 201

    return api_render_one({ token: }) unless browser_request?

    redirect '/account/manage'
  end

  post '/log_in' do
    email = params[:email]
    password = params[:password]

    user = User::Login.new(user_email: email).from_password(password).call

    unless user
      flash[:error] = 'Email or password does not exist'
      redirect '/account/log_in'
    end

    token = JWTService.encode(user.as_json)

    set_jwt_token(token)

    status 200
    return api_render_one({ token: }) unless browser_request?

    flash[:success] = 'Login successful!'
    redirect '/account/manage'
  end

  get '/confirm/:code' do |code|
    err_msg = User::ConfirmEmail.new(user_id: @current_user.id).with_code(code).call

    if err_msg
      flash[:error] = err_msg
      return redirect '/account/email-verify'
    end

    flash[:success] = 'Email confirmed!'
    redirect '/'
  end

  get '/manage' do
    authenticate!

    render! :manage
  end

  get '/verify-email' do
    email_unverified!

    email = User::Select.new.email_code(@current_user.id)

    return redirect '/account/email-verify' if email

    email = User::GenerateEmailCode.new.from_user(@current_user).call
    email_code = email.id

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
    email_unverified!

    User::ResendEmail.new(user_id: @current_user.id).call

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
