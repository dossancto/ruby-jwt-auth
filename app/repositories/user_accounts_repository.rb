# frozen_string_literal: true

require 'sinatra/activerecord'

## UserAccountsRepository
class UserAccountsRepository < ActiveRecord::Base
  validates_presence_of :user_name, :password, :email

  self.table_name = 'user_accounts'
end
