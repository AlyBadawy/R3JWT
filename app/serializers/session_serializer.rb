class SessionSerializer
  include JSONAPI::Serializer

  set_key_transform :camel_lower

  attributes :ip, :user_agent, :logged_out, :created_at, :updated_at
  belongs_to :user
end
