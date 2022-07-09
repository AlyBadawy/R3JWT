module TokenHelper
  module_function

  def payload_from_session(session)
    data = { user_id: session.user.id, username: session.user.username }
    exp = Time.zone.now.to_i + ENV.fetch("TOKEN_EXPIRY").to_i
    iss = ENV.fetch("TOKEN_ISSUER")
    jti = session.id
    { data: data, exp: exp, iss: iss, jti: jti }
  end

  def jwt_from_payload(payload)
    JWT.encode(
      payload,
      ENV.fetch("HMAC_SECRET"),
      ENV.fetch("HMAC_ALGO"),
      { typ: "JWT" }
    )
  end

  def session_from_valid_jti(jti)
    session = Session.find_by(id: jti)
    return session unless session&.logged_out

    nil
  end

  def session_from_valid_refresh_token(jwt, refresh_token)
    jti = decode_expired_token(jwt).first["jti"]
    session = session_from_valid_jti(jti)&.authenticate_refresh_token(refresh_token)
    return session if session && session.updated_at + ENV.fetch("REFRESH_TOKEN_EXPIRY") >= Time.zone.now

    nil
  end

  def decode_token(jwt)
    JWT.decode(
      jwt,
      ENV.fetch("HMAC_SECRET"),
      true,
      {
        iss:               ENV.fetch("TOKEN_ISSUER"),
        verify_iss:        true,
        verify_expiration: true,
        verify_jti:        proc { |jti| session_from_valid_jti(jti) },
        algorithm:         ENV.fetch("HMAC_ALGO"),
        exp_leeway:        120,
      }
    )
  end

  def decode_expired_token(jwt)
    JWT.decode(
      jwt,
      ENV.fetch("HMAC_SECRET"),
      true,
      {
        iss:               ENV.fetch("TOKEN_ISSUER"),
        verify_iss:        true,
        verify_expiration: false,
        verify_jti:        proc { |jti| session_from_valid_jti(jti) },
        algorithm:         ENV.fetch("HMAC_ALGO"),
      }
    )
  end
end
