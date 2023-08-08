module Asaas
  class DocumentFile < Model

    attribute :id, Types::Coercible::String.optional.default(nil)
    attribute :status, Types::Coercible::String.optional.default(nil)

  end
end
