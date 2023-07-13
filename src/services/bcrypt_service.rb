require 'bcrypt'

module BcryptService
  include BCrypt

  def self.encode_password(password)
    Password.create(password)
  end
end
