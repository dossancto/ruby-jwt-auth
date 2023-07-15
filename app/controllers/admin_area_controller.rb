# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require 'json'
require './app/controllers/application_controller'

## AdminAreaController
class AdminAreaController < ApplicationController
  before '/admin*' do
    authenticate!
    authorize! [:admin]
  end

  get '/admin' do
    @current_user.to_json
  end
end
