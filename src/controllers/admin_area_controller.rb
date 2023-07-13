# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require_relative '../middlewares/user_middleware'

## AdminAreaController
class AdminAreaController < UserMiddleware
  before '/admin*' do
    authenticate!
    authorize! [:admin]
  end

  get '/admin' do
    @current_user.to_json
  end
end
