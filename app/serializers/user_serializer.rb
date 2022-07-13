class UserSerializer
  include JSONAPI::Serializer

  set_key_transform :camel_lower

  attributes :username, :email, :created_at, :updated_at
end
