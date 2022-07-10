class ApplicationController < ActionController::API
  include RecordExceptionHandler
  include JwtExceptionHandler
  include AuthExceptionHandler

  include JwtAuthenticatable

  include JSONAPI::Deserialization

  def jsonapi_meta(resources)
    meta = { provider: ENV.fetch("API_PROVIDER") }
    meta[:total] = resources.count if resources.respond_to?(:count)

    meta
  end
end
