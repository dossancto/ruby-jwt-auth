require 'bcrypt'

module BcryptService
  include BCrypt

  def self.encode_password(password)
    Password.create(password)
  end

  def self.decode_password(hash_password)
    BCrypt::Password.new(hash_password)
  end
end
