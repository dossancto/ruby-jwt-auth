# frozen_string_literal: true

# require 'sinatra/activerecord'

## UserAccounts
class UserAccounts
  attr_accessor :user_name, :password, :email, :email_confirmed, :roles

  def initialize(user_name, password, email, email_confirmed, roles)
    @user_name = user_name
    @password = password
    @email = email
    @email_confirmed = email_confirmed
    @roles = roles
  end

  def to_hash
    {
      user_name:,
      password:,
      email:,
      email_confirmed:,
      roles:
    }
  end
end
