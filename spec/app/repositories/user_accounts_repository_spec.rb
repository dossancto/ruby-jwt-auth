# frozen_string_literal: true

require './spec/spec_helper'
require './app/repositories/user_accounts_repository'
require './app/services/bcrypt_service'
require './app/adapters/usecases/user/index'
require './app/repositories/user_accounts_repository'

RSpec.describe UserAccountsRepository do
  let(:valid_user_params) do
    {
      user_name: 'JohnDoe',
      password: 'password123',
      email: 'johndoe@example.com'
    }
  end

  describe '.user_from_email_password' do
    context 'when valid email and password are provided' do
      it 'returns the user if the email and password match' do
        user = User::Register.new(params: valid_user_params).call

        allow(UserAccountsRepository).to receive(:find_by).with(email: 'johndoe@example.com').and_return(user)

        result = User::Login.new(user_email: 'johndoe@example.com').from_password('password123').call

        expect(result).to eq(user)
      end
    end

    context 'when invalid email or password are provided' do
      it 'returns nil' do
        user = User::Register.new(params: { user_name: 'JohnDoe', password: 'correctPassword',
                                            email: 'johndoe@example.com' }).call

        allow(UserAccountsRepository).to receive(:find_by).with(email: 'johndoe@example.com').and_return(user)

        result = User::Login.new(user_email: 'johndoe@example.com').from_password('wrongpassword').call

        expect(result).to be_nil
      end
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

  describe '.new_from_params' do
    it 'creates a new user with the provided parameters' do
      user = User::Register.new(params: valid_user_params).call

      # Assert the user is created with the correct parameters and saved
      expect(user.user_name).to eq('JohnDoe')
      expect(BcryptService.decode_password(user.password)).to eq('password123')
      expect(user.email).to eq('johndoe@example.com')
      expect(user.roles).to eq(%w[admin user])
    end
  end
end
