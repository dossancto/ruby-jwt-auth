# frozen_string_literal: true

require 'bcrypt'
require_relative '../models/user_accounts_email_tokens'
require_relative '../services/bcrypt_service'

# one day
MAX_AGE = 24 * 60 * 60

## UserAccountsRepository
module UserAccountsEmailTokensRepository
  def self.new_email_token(user)
    puts MAX_AGE
    valid_for = Time.now + MAX_AGE
    puts "TOKEN VALID FOR #{valid_for}"
    email = UserAccountsEmailTokens.new
    email.user_id = user.id
    email.creted_at = Time.now
    email.valid_for = valid_for

    email.save

    email.id
  end

  def self.user_id_from_code(code)
    email = UserAccountsEmailTokens.find_by(id: code)

    email.user_id
  end

  def self.token_from_user(user)
    email = UserAccountsEmailTokens.find_by(user_id: user.id)

    return nil unless email

    email
  end

  def self.email_tokem_from_code(code)
    UserAccountsEmailTokens.find_by(id: code)
  end

  def self.destroy_code(user)
    UserAccountsEmailTokens.where(user_id: user.id).delete_all
  end
end
