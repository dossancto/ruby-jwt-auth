# frozen_string_literal: true

require 'sinatra/activerecord'

## UserAccountsRepository
class UserAccountsRepository < ActiveRecord::Base
  validates_presence_of :user_name, :password, :email

  self.table_name = 'user_accounts'

  def access?(roles:)
    self.roles.any? do |role|
      roles.any? { |r| r.to_s == role.to_s }
    end
  end
end
