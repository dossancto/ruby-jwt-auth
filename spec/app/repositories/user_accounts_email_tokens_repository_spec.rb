# frozen_string_literal: true

require './spec/spec_helper'
require './app/repositories/user_accounts_email_tokens_repository'
require './app/repositories/user_accounts_repository'
require './app/models/user_accounts_email_tokens'

RSpec.describe UserAccountsEmailTokensRepository do
  let(:valid_user_params) do
    {
      user_name: 'JohnDoe',
      password: 'password123',
      email: 'johndoe@example.com'
    }
  end

  let(:user) { UserAccountsRepository.new_from_params(valid_user_params) }

  context 'with new email token' do
    let(:email_confirm) { UserAccountsEmailTokensRepository.new_email_token(user) }

    it { expect(email_confirm.class).to be(UserAccountsEmailTokens) }

    it { expect(email_confirm.user_id).to eq(user.id) }
  end

  context 'confirm email code' do
    it do
      UserAccountsEmailTokensRepository.new_email_token(user)

      UserAccountsEmailTokensRepository.destroy_code(user)

      count = UserAccountsEmailTokens.where(user_id: user.id).count
      expect(count).to eq(0)
    end
  end
end
