# frozen_string_literal: true

require 'bcrypt'
require './app/models/user_accounts'
require './app/services/bcrypt_service'

## UserAccountsRepository
module UserAccountsRepository
  def self.user_from_email_password(email, password)
    user = UserAccounts.find_by(email:)

    puts 'email not found' unless user
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
end
