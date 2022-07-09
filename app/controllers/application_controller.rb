class ApplicationController < ActionController::API
  include RecordExceptionHandler
  include JwtExceptionHandler
end
