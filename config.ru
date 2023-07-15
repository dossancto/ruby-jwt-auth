# frozen_string_literal: true

require 'sinatra'
require 'sinatra/base'

Dir.glob('./app/{helpers,controllers}/*.rb').each { |file| require file }

# Routes
map('/') { run PublicAreaController }

map('/account') { run AccountController }

map('/admin') { run AdminAreaController }
