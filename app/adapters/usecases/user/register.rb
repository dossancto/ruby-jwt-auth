# frozen_string_literal: true

require './app/repositories/user_accounts_repository'
require './app/repositories/user_accounts_email_tokens_repository'
require './app/models/user_accounts'

module User
  ## Create
  class Register
    def initialize(params:, user: UserAccounts, user_repository: UserAccountsRepository)
      @params = params
      @user = user
      @user_repository = user_repository
    end

    def call
      user = @user.new

      user.user_name = params[:user_name]
      user.password = BcryptService.encode_password(params[:password])
      user.email = params[:email]
      user.roles = %w[admin user]

      user.save

      user
    end
  end
end
