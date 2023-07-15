# frozen_string_literal: true

## CookieHelper
module CookieHelper
  def set_jwt_token(token)
    response.set_cookie(:jwt_token, {
                          value: token,
                          expires: Time.now + 3600,  # Expires in 1 hour
                          path: '/',                 # Cookie available for all routes
                          secure: true,              # Only send the cookie over HTTPS
                          http_only: true            # Restrict cookie access to HTTP requests only
                        })
  end

  def invalidate_jwt_token!
    response.set_cookie(:jwt_token, {
                          value: nil,
                          expires: Time.now + 3600,  # Expires in 1 hour
                          path: '/',                 # Cookie available for all routes
                          secure: true,              # Only send the cookie over HTTPS
                          http_only: true            # Restrict cookie access to HTTP requests only
                        })
  end
end
