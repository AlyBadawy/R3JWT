class ApplicationController < ActionController::API
  include RecordExceptionHandler
  include JwtExceptionHandler
  include AuthExceptionHandler

  include JwtAuthenticatable
end
