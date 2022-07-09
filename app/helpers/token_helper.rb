module TokenHelper
  module_function

  def payload_from_login(login)
    data = { user_id: login.user.id, username: login.user.username }
    exp = Time.now.to_i + ENV.fetch("TOKEN_EXPIRY").to_i
    iss = ENV.fetch("TOKEN_ISSUER")
    jti = login.id
    { data: data, exp: exp, iss: iss, jti: jti }
  end

  def encode_payload(payload)
    JWT.encode(
      payload,
      ENV.fetch("HMAC_SECRET"),
      ENV.fetch("HMAC_ALGO"),
      { typ: "JWT" }
    )
  end

  def valid_jti(jti)
    login = Login.find_by(id: jti)
    return login unless login&.logged_out

    nil
  end

  def valid_refresh_token(token, refresh_token)
    jti = validate_expired_token(token).first["jti"]
    login = valid_jti(jti).authenticate_refresh_token(refresh_token)
    return login if login && login.updated_at + ENV.fetch("REFRESH_TOKEN_EXPIRY") >= Time.now

    nil
  end

  def decode_token(token)
    JWT.decode(
      token,
      ENV.fetch("HMAC_SECRET"),
      true,
      {
        iss: ENV.fetch("TOKEN_ISSUER"),
        verify_iss: true,
        verify_expiration: true,
        verify_jti: proc { |jti| valid_jti(jti) },
        algorithm: ENV.fetch("HMAC_ALGO"),
        exp_leeway: 120,
      }
    )
  end

  def validate_expired_token(token)
    JWT.decode(
      token,
      ENV.fetch("HMAC_SECRET"),
      true,
      {
        iss: ENV.fetch("TOKEN_ISSUER"),
        verify_iss: true,
        verify_expiration: false,
        verify_jti: proc { |jti| valid_jti(jti) },
        algorithm: ENV.fetch("HMAC_ALGO"),
      }
    )
  end
end
