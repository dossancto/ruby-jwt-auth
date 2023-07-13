# frozen_string_literal: true

require 'sinatra/base'
require 'json'

## AdminAreaController
class PublicAreaController < Sinatra::Base
  get '/public' do
    p 'Public Area'
  end
end
