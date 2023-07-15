# frozen_string_literal: true

## AuthService
module AuthHelper
  def current_user(request)
    token = request.env['http_authorization']&.split(' ')&.last
    token ||= request.cookies['jwt_token']

    JWTService.get_user(token)
  end

  def authenticate!(route = '/account/verify-email')
    return invalid_user unless @current_user

    return redirect route unless @current_user.email_confirmed
  end

  def email_unverified!(route = '/')
    return invalid_user unless @current_user

    return redirect route if @current_user.email_confirmed
  end

  def authorize!(roles, route = '/')
    user_roles = @current_user['roles']

    has_access = user_roles.any? do |role|
      roles.any? { |r| r.to_s == role.to_s }
    end

    redirect route unless has_access
  end

  def unnathenticate!(route = '/account/manage')
    redirect route if @current_user
  end

  def invalid_user
    response.delete_cookie(:jwt_token)
    redirect '/account/log_in'
  end
end
