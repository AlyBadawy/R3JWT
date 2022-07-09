module JwtExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from JWT::ExpiredSignature do
      json_response({ errors: ["Expired Token. Refresh Token or login again"] }, :unauthorized)
    end

    rescue_from JWT::EncodeError do
      json_response({ errors: ["can't generate Token. Please login again"] }, :unauthorized)
    end

    rescue_from JWT::DecodeError do
      json_response({ errors: ["Invalid Token. Please login again"] }, :unauthorized)
    end
  end
end
