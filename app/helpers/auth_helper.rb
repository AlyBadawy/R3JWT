module AuthHelper
  class AuthenticationError < StandardError; end
  class WrongCredentials < AuthenticationError; end
  class ExpiredToken < AuthenticationError; end

  module_function

  def login(username, password, ip, user_agent)
    user = User.find_by(username: username)
    raise WrongCredentials unless user&.authenticate_password(password)

    refresh_token = SecureRandom.hex(32)
    login = Login.create(user: user,
                         refresh_token: refresh_token,
                         ip: ip,
                         user_agent: user_agent)

    payload = TokenHelper.payload_from_login login
    token = TokenHelper.encode_payload payload

    { token: token, refresh_token: refresh_token, exp: payload[:exp] }
  end

  def refresh(jwt, refresh_token, ip, user_agent)
    login = TokenHelper.valid_refresh_token(jwt, refresh_token)
    raise ExpiredToken unless login

    refresh_token = SecureRandom.hex(32)
    payload = TokenHelper.payload_from_login login
    token = TokenHelper.encode_payload payload
    login.update(refresh_token: refresh_token,
                 ip: ip,
                 user_agent: user_agent)

    { token: token, refresh_token: refresh_token, exp: payload[:exp] }
  end

  def logout(jwt)
    decoded_token = TokenHelper.decode_token(jwt)
    jti = decoded_token.first["jti"]
    Login.find_by(id: jti).update(logged_out: true)
  end
end
