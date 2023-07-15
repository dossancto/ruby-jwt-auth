# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require './app/controllers/application_controller'

## AdminAreaController
class AdminAreaController < ApplicationController
  before do
    authenticate!
    authorize! [:admin]
  end

  get '/' do
    @current_user.to_json
  end
end
