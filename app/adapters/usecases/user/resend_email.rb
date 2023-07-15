# frozen_string_literal: true

require './app/repositories/user_accounts_email_tokens_repository'

module User
  ## Create
  class ResendEmail
    def initialize(user_id:, email_repository: UserAccountsEmailTokensRepository)
      @user_id = user_id
      @email_repository = email_repository
    end

    def call
      @email_repository.where(user_id: @user_id).delete_all
    end
  end
end
