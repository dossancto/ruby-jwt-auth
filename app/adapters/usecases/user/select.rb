# frozen_string_literal: true

require './app/repositories/user_accounts_repository'
require './app/repositories/user_accounts_email_tokens_repository'
require './app/models/user_accounts'

module User
  ## Select
  class Select
    def initialize(user_repository: UserAccountsRepository, email_repository: UserAccountsEmailTokensRepository)
      @user_repository = user_repository
      @email_repository = email_repository
    end

    def with_id(id)
      @user_repository.find_by(id:)
    end

    def email_code(user_id)
      email = @email_repository.find_by(user_id:)

      return nil unless email

      email
    end
  end
end
