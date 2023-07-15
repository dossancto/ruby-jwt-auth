# frozen_string_literal: true

require 'bcrypt'
require './app/models/user_accounts'
require './app/services/bcrypt_service'

## UserAccountsRepository
module UserAccountsRepository
  def self.user_from_email_password(email, password)
    user = UserAccounts.find_by(email:)

    return user if user && BCrypt::Password.new(user.password) == password

    nil
  end

  def self.user_by_id(id)
    UserAccounts.find_by(id:)
  end

  def self.confirm_email(user)
    user.email_confirmed = true
    user.save
  end

  def self.new_from_params(params)
    user = UserAccounts.new

    user.user_name = params[:user_name]
    user.password = BcryptService.encode_password(params[:password])
    user.email = params[:email]
    user.roles = %w[admin user]

    user.save

    user
  end
end
