# frozen_string_literal: true

require './app/models/user_accounts_email_tokens'
require 'sinatra/activerecord'

# one day
MAX_AGE = 24 * 60 * 60

## UserAccountsRepository
class UserAccountsEmailTokensRepository < ActiveRecord::Base
  validates_presence_of :user_id, :valid_for
  self.table_name = 'user_accounts_email_tokens'
end
