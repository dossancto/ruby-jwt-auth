# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.require(:default)                   # load all the default gems
Bundler.require(Sinatra::Base.environment)  # load all the environment specific gems

require 'active_support/deprecation'
require 'active_support/all'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'sinatra'
require 'dotenv'
Dotenv.load

set :database_file, 'database.yml'