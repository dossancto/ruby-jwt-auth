# frozen_string_literal: true

## UserAccountsEmailTokens
class UserAccountsEmailTokens
  attr_accessor :user_id, :creted_at, :valid_for, :created_at

  def initialize(user_id, valid_for)
    @user_id = user_id
    @created_at = created_at
    @valid_for = valid_for
  end

  def to_hash
    {
      user_id:,
      valid_for:
    }
  end
end
