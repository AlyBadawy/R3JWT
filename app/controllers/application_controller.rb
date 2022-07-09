class ApplicationController < ActionController::API
  include RecordExceptionHandler
  include JwtExceptionHandler
  include JwtAuthenticatable
end
