Rails.application.configure do
  config.lograge.enabled = true

  config.lograge.base_controller_class = ['ActionController::API', 'ActionController::Base']

  config.lograge.custom_payload do |controller|
    {
      host:       controller.request.host,
      user_id:    controller.current_user&.id,
      session_id: controller.current_session&.id,
      remote_ip:  controller.request.remote_ip,
      request_id: controller.request.request_id,
    }
  end
  

  config.lograge.custom_options = lambda do |event|
    return { event_payload: "null" } unless event.payload

    {
      time:       Time.zone.now,
      request_id: event.payload[:request_id],
      host:       event.payload[:host],
      remote_ip:  event.payload[:remote_ip],
      user_id:    event.payload[:user_id],
      session_id: event.payload[:session_id],
      params:     event.payload[:params],
    }

  end
end
