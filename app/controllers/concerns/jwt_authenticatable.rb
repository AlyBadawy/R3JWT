module JwtAuthenticatable
  extend ActiveSupport::Concern

  include ActionController::HttpAuthentication::Token::ControllerMethods

  attr_accessor :current_session, :current_user

  # Use this to raise an error and automatically respond with a 401 HTTP status
  # code when API key authentication fails
  def authenticate_user!
    @current_user = authenticate_or_request_with_http_token { |jwt| user_authenticator jwt }
  end

  def authenticate_admin!
    @current_user = authenticate_or_request_with_http_token { |jwt| admin_authenticator jwt }
  end

  private

  def user_authenticator(jwt_token)
    decoded_token = TokenHelper.decode_token(jwt_token)
    jti = decoded_token.first["jti"]
    @current_session = TokenHelper.session_from_valid_jti(jti)
    return false unless @current_session

    @current_session&.user
  end

  def admin_authenticator(jwt_token)
    raise AuthHelper::RestrictedAccessError unless user_authenticator(jwt_token)&.admin

    @current_session&.user
  end
end
