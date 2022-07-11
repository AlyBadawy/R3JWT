module AuthExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from AuthHelper::WrongCredentialsError do
      render json: { errors: ["Invalid Credentials."] }, status: :unauthorized
    end

    rescue_from AuthHelper::ExpiredTokenError do
      render json: { errors: ["Token Expired. Please refresh token or login again"] }, status: :unauthorized
    end

    rescue_from AuthHelper::RestrictedAccessError do
      render json: { errors: ["You don't have permission to access this resource"] }, status: :forbidden
    end
  end
end
