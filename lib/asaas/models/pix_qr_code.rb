
module Asaas
  class PixQrCode < Model
    attribute :success, Types::Coercible::String
    attribute :encodedImage, Types::Coercible::String
    attribute :payload, Types::Coercible::String
    attribute :expirationDate, Types::Coercible::String
  end
end