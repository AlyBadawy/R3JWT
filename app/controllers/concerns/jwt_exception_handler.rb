module JwtExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from JWT::ExpiredSignature do
      render json: { errors: ["Expired Token. Refresh Token or login again"] }, status: :unauthorized
    end

    rescue_from JWT::EncodeError do
      render json: { errors: ["can't generate Token. Please login again"] }, status: :unauthorized
    end

    rescue_from JWT::DecodeError do
      render json: { errors: ["Invalid Token. Please login again"] }, status: :unauthorized
    end
  end
end
