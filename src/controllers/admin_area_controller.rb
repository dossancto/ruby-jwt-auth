# frozen_string_literal: true

require 'sinatra/base'
# require_relative '../middlewares/jwt_auth'
require_relative '../services/jwt_service'

## AdminAreaController
class AdminAreaController < Sinatra::Base
  set(:auth) do |*_roles|
    condition do
      token = request.env['HTTP_AUTHORIZATION']&.split(' ')&.last
      token ||= request.cookies['jwt_token']

      redirect '/account/log_in' unless token

      begin
        redirect '/user-not-found' unless JWTService.get_user(token)
      rescue StandardError
        redirect '/invalid-token'
      end
    end
  end

  get '/admin', auth: [:admin] do
    'Autentucado'
  end
end
