class ApplicationController < ActionController::API
  include RecordExceptionHandler
  include JwtExceptionHandler
  include AuthExceptionHandler
  include JwtAuthenticatable

  include JSONAPI::Deserialization

  before_action :underscore_params!

  private

  def jsonapi_meta(resources)
    meta = { provider: ENV.fetch("API_PROVIDER") }
    meta[:total] = resources.count if resources.respond_to?(:count)

    meta
  end

  def underscore_params!
    params.deep_transform_keys! do |key|
      ["Access-Token", "Refresh-Token"].include?(key) ? key : key.underscore
    end
  end
end
