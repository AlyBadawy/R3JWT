module AuthExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from AuthHelper::WrongCredentials do
      render json: { errors: ["Invalid Credentials."] }, status: :unauthorized
    end

    rescue_from AuthHelper::ExpiredToken do
      render json: { errors: ["Token Expired. Please refresh token or login again"] }, status: :unauthorized
    end
  end
end
