module Asaas
  class DocumentResponsible < Model

    attribute :name, Types::Coercible::String.optional.default(nil)
    attribute :type, Types::Coercible::String.optional.default(nil)

  end
end
