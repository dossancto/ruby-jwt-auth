# frozen_string_literal: true

require './spec/spec_helper'
require './app/adapters/usecases/user/index'
require './app/models/user_accounts_email_tokens'

RSpec.describe User do
  let(:valid_user_params) do
    {
      user_name: 'JohnDoe',
      password: 'password123',
      email: 'johndoe@example.com'
    }
  end

  context 'with new email token' do
    it 'New email code is generated' do
      user = User::Register.new(params: valid_user_params).call
      email = User::GenerateEmailCode.new.from_user(user).call
      expect(email.class).to be(UserAccountsEmailTokensRepository)

      expect(email.user_id).to eq(user.id)
    end
  end

  describe '.confirm_email' do
    it 'updates the user email_confirmed attribute to true' do
      user = User::Register.new(params: { user_name: 'JohnDoe', password: 'correctPassword',
                                          email: 'johndoe@example.com' }).call

      allow(UserAccountsRepository).to receive(:find_by).with(email: 'johndoe@example.com').and_return(user)

      email = User::GenerateEmailCode.new.from_user(user).call

      expect(user.email_confirmed).to eq(false)

      allow(UserAccountsRepository).to receive(:find_by).with(id: user.id).and_return(user)

      User::ConfirmEmail.new(user_id: user.id).with_code(email.id).call

      expect(user.email_confirmed).to eq(true)
    end
  end
end
