# frozen_string_literal: true

require './app/repositories/user_accounts_repository'
require './app/models/user_accounts_email_tokens'

MAX_AGE = 24 * 60 * 60

module User
  ## Create
  class GenerateEmailCode
    def initialize(email_model: UserAccounts, user_repository: UserAccountsRepository,
                   email_repository: UserAccountsEmailTokensRepository)
      @email_model = email_model
      @user_repository = user_repository
      @email_repository = email_repository
    end

    def from_user(user)
      @user = user
      self
    end

    def call
      valid_for = Time.now + MAX_AGE

      email = UserAccountsEmailTokens.new(@user.id, valid_for)

      @email_repository.create!(email.to_hash)
    end
  end
end
