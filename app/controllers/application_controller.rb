# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'

require './app/services/jwt_service'

require './app/repositories/user_accounts_repository'

## UserMiddleware
class ApplicationController < Sinatra::Base
  include AuthHelper

  configure do
    register Sinatra::Flash
    enable :sessions
    set :public_folder, File.expand_path('../../public/', __dir__)
    set :views, File.expand_path('../views', __dir__)
  end

  configure :production, :development do
    enable :logging
  end

  before do
    @current_user ||= current_user(request)
  end
end
