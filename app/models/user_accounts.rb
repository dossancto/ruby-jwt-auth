# frozen_string_literal: true

require 'sinatra/activerecord'

## UserAccounts
class UserAccounts < ActiveRecord::Base
  validates_presence_of :user_name, :password, :email
end
