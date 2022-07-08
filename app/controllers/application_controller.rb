class ApplicationController < ActionController::API
  def jsonapi_meta(resources)
    { total: resources.count } if resources.respond_to?(:count)
  end

  def jsonapi_serializer_params
    {
      type: params[:upcase].present?,
    }
  end
end
