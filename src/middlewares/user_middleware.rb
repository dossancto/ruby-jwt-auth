# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require_relative '../services/jwt_service'
require_relative '../repositories/user_accounts_repository'

## UserMiddleware
class UserMiddleware < Sinatra::Base
  register Sinatra::Flash

  before do
    puts "[#{Time.now}] before running"
    @current_user ||= current_user(request)
    puts @current_user
  end

  after do
    puts "[#{Time.now}] after running"
    @current_user = nil
    puts @current_user
  end

  def current_user(request)
    token = request.env['http_authorization']&.split(' ')&.last
    token ||= request.cookies['jwt_token']

    @current_user ||= JWTService.get_user(token)
  end

  def authenticate!(route = '/account/verify-email')
    return invalid_user unless @current_user

    return redirect route unless @current_user.email_confirmed
  end

  def authorize!(roles, route = '/')
    user_roles = @current_user['roles']

    has_access = user_roles.any? do |role|
      roles.any? { |r| r.to_s == role.to_s }
    end

    redirect route unless has_access
  end

  def unnathenticate!(route = '/account/manage')
    redirect route if @current_user
  end

  private

  def invalid_user
    response.delete_cookie(:jwt_token)
    redirect '/account/log_in'
  end
end
