# frozen_string_literal: true

require 'sinatra/activerecord'

## UserAccounts
class UserAccountsEmailTokens < ActiveRecord::Base
  validates_presence_of :user_id, :creted_at, :valid_for
end
