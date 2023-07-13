# frozen_string_literal: true

require_relative '../services/jwt_service'

## JwtAuthMiddleware
class JwtAuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    token = request.env['HTTP_AUTHORIZATION']&.split(' ')&.last

    return unauthorized_response unless token

    validate_jwt(token, env)
  end

  def validate_jwt(token, env)
    jwt = JWTService.new

    user = jwt.get_user(token)
    user_id = user['user_id']

    if validate_user(user_id)
      status, headers, response = @app.call(env)
      [status, headers, response]
    end
  rescue JWT::DecodeError, JWT::VerificationError
    'invalid token'
  end

  def validate_user(user_id)
    valid_user_ids = [1, 2, 3]
    valid_user_ids.include?(user_id)
  end

  def unauthorized_response
    [401, { 'Content-Type' => 'text/plain' }, ['Unauthorized']]
  end
end
