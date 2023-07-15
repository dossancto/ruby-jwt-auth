# frozen_string_literal: true

require './app/repositories/user_accounts_repository'
require './app/models/user_accounts'
require 'bcrypt'

module User
  ## Create
  class Login
    def initialize(user_email:, user_model: UserAccounts, user_repository: UserAccountsRepository)
      @user_email = user_email
      @user_model = user_model
      @user_repository = user_repository
    end

    def from_password(password)
      @password = password
      self
    end

    def call
      user = @user_repository.find_by(email: @user_email)

      return user if user && BCrypt::Password.new(user.password) == @password
    end
  end
end
