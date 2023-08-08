
module Asaas
  class Documents < Model
    
    attribute :rejectReasons, Types::Coercible::String.optional
    attribute :data, Types::Array.of(DocumentRequest).optional.default([])
  end
end