class UserSerializer
  include JSONAPI::Serializer

  attributes :username, :email, :created_at, :updated_at
end
