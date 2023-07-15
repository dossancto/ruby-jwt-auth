# frozen_string_literal: true

require './app/repositories/user_accounts_repository'
require './app/repositories/user_accounts_email_tokens_repository'
require './app/models/user_accounts'

module User
  ## Create
  class ConfirmEmail
    def initialize(user_id:, user_model: UserAccounts, user_repository: UserAccountsRepository,
                   email_repository: UserAccountsEmailTokensRepository)
      @user_id = user_id
      @user_model = user_model
      @user_repository = user_repository
      @email_repository = email_repository
    end

    def with_code(code)
      @code = code
      self
    end

    def call
      valid_msg = valid_code?
      return valid_msg if valid_msg

      user = @user_repository.find_by(id: @user_id)
      user.email_confirmed = true
      user.save

      @email_repository.where(user_id: @user_id).delete_all

      nil
    end

    private

    def valid_code?
      email = @email_repository.find_by(id: @code)
      return 'invalid code' unless email

      user_id = email.user_id

      return 'Code expired' if Time.now.utc >= email.valid_for
      return 'invalid code' if user_id != @user_id

      nil
    end
  end
end
