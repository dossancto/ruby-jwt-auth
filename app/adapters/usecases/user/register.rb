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
      password = BcryptService.encode_password(@params[:password])
      user = @user.new(@params[:user_name], password, @params[:email], %w[admin user])

      @user_repository.create!(user.to_hash)
    end
  end
end
