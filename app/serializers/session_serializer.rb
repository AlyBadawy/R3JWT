class SessionSerializer
  include JSONAPI::Serializer

  attributes :ip, :user_agent, :logged_out, :created_at, :updated_at
  belongs_to :user
end
