# frozen_string_literal: true

require 'dotenv'
require 'jwt'
require './app/adapters/usecases/user/index'

Dotenv.load

ALGORITHM = ENV['JWT_ALGORITHM']
SECRET_KEY = ENV['JWT_SECRET_KEY']

## JWTService
module JWTService
  def self.encode(payload)
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })
  end

  def self.get_user(token)
    jwt_user = decode(token)[0]
    jwt_user_id = jwt_user['id']

    User::Select.new.with_id(jwt_user_id)
    # TODO: Get user in database
  rescue StandardError
    puts 'jwt.service [line:30]'
    puts $!
    nil
  end

  def self.valid_token?(token, user)
    token = get_user(token)
    token['id'] == user['id']
  rescue JWT::DecodeError, JWT::VerificationError
    puts "Error while decoding #{token}"
    false
  end
end
