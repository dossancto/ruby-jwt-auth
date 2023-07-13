# frozen_string_literal: true

require 'sinatra/base'
require_relative '../services/jwt_service'

## UserMiddleware
class UserMiddleware < Sinatra::Base
  before do
    token = request.env['HTTP_AUTHORIZATION']&.split(' ')&.last
    token ||= request.cookies['jwt_token']

    @current_user = JWTService.get_user(token)
  end

  def authenticate!
    redirect '/account/log_in' unless @current_user
  end

  def authorize!(*roles)
    user_roles = @current_user['roles']

    has_access = user_roles.any? do |role|
      roles.any? { |r| r.to_s == role.to_s }
    end

    redirect route unless has_access
  end

  def unnathenticate!(route = '/account/manage')
    redirect route if @current_user
  end
end
