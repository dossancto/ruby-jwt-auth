# frozen_string_literal: true

require './spec/spec_helper'
require './app/repositories/user_accounts_repository'
require './app/services/bcrypt_service'

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
        # Create a mock user
        user = UserAccounts.new(email: 'johndoe@example.com', password: BcryptService.encode_password('password123'))
        allow(UserAccounts).to receive(:find_by).with(email: 'johndoe@example.com').and_return(user)

        # Call the method under test
        result = UserAccountsRepository.user_from_email_password('johndoe@example.com', 'password123')

        # Assert the result
        expect(result).to eq(user)
      end
    end

    context 'when invalid email or password are provided' do
      it 'returns nil' do
        # Create a mock user
        user = UserAccounts.new(email: 'johndoe@example.com', password: BcryptService.encode_password('password123'))
        allow(UserAccounts).to receive(:find_by).with(email: 'johndoe@example.com').and_return(user)

        # Call the method under test with wrong password
        result = UserAccountsRepository.user_from_email_password('johndoe@example.com', 'wrongpassword')

        # Assert the result
        expect(result).to be_nil
      end
    end
  end

  describe '.user_by_id' do
    it 'returns the user with the specified ID' do
      # Create a mock user
      user = UserAccounts.new(id: 1)
      allow(UserAccounts).to receive(:find_by).with(id: 1).and_return(user)

      # Call the method under test
      result = UserAccountsRepository.user_by_id(1)

      # Assert the result
      expect(result).to eq(user)
    end
  end

  describe '.confirm_email' do
    it 'updates the user email_confirmed attribute to true' do
      # Create a mock user
      user = UserAccounts.new
      allow(user).to receive(:save)

      # Call the method under test
      UserAccountsRepository.confirm_email(user)

      # Assert the user's email_confirmed attribute is updated
      expect(user.email_confirmed).to be true
      expect(user).to have_received(:save)
    end
  end

  describe '.new_from_params' do
    it 'creates a new user with the provided parameters' do
      # Create a mock user
      user = UserAccounts.new
      allow(UserAccounts).to receive(:new).and_return(user)
      allow(user).to receive(:save)

      # Call the method under test
      result = UserAccountsRepository.new_from_params(valid_user_params)

      # Assert the user is created with the correct parameters and saved
      expect(result).to eq(user)
      expect(user.user_name).to eq('JohnDoe')
      expect(BcryptService.decode_password(user.password)).to eq('password123')
      expect(user.email).to eq('johndoe@example.com')
      expect(user.roles).to eq(%w[admin user])
      expect(user).to have_received(:save)
    end
  end
end
