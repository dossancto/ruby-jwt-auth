# frozen_string_literal: true

# Rakefile
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require './config/environment'

namespace :db do
end

task :build_tailwind do
  system('npm run build:css')
end

task :start_server do
  system('bundle exec puma')
end

desc 'Build Tailwind CSS and start the server'
task run: %i[build_tailwind start_server]
task up: %i[start_server]
