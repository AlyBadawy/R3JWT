class UserSerializer
  include JSONAPI::Serializer

  attributes :username, :email, :admin
end
