# frozen_string_literal: true

require 'sinatra/base'
require_relative '../middlewares/jwt_auth'

## AdminAreaController
class AccountController < Sinatra::Base
  get '/account/log_in' do
    'Pleace log in'
  end
end
