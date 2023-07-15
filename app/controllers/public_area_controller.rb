# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require './app/controllers/application_controller'

## AdminAreaController
class PublicAreaController < ApplicationController
  get '/' do
    render! :index
  end
end
