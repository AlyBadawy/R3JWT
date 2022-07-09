module AuthHelper
  class AuthenticationError < StandardError; end
  class WrongCredentials < AuthenticationError; end
  class ExpiredToken < AuthenticationError; end

  module_function

  def login(username, password, ip = "0.0.0.0", user_agent = "unknown_agent")
    user = User.find_by(username: username)
    raise WrongCredentials unless user&.authenticate_password(password)

    refresh_token = SecureRandom.hex(32)
    session = Session.create(user: user,
                             refresh_token: refresh_token,
                             ip: ip,
                             user_agent: user_agent)

    payload = TokenHelper.payload_from_session session
    jwt = TokenHelper.jwt_from_payload payload

    { jwt: jwt, refresh_token: refresh_token, exp: payload[:exp] }
  end

  def refresh(jwt, refresh_token)
    session = TokenHelper.session_from_valid_refresh_token(jwt, refresh_token)
    raise WrongCredentials unless session

    refresh_token = SecureRandom.hex(32)
    payload = TokenHelper.payload_from_session session
    jwt = TokenHelper.jwt_from_payload payload
    session.update(refresh_token: refresh_token)

    { jwt: jwt, refresh_token: refresh_token, exp: payload[:exp] }
  end

  def logout(jwt)
    decoded_token = TokenHelper.decode_token(jwt)
    jti = decoded_token.first["jti"]
    Session.find_by(id: jti).update(logged_out: true)
  end
end
