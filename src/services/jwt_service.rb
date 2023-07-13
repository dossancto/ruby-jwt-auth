# frozen_string_literal: true

require 'dotenv'
require 'jwt'

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
    decode(token)[0]
    # user_id = jwt_user['id']
    # TODO: Get user in database
  rescue StandardError
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
