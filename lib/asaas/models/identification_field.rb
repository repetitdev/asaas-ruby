module Asaas
    class IdentificationField < Model
      attribute :identificationField, Types::Coercible::String
      attribute :nossoNumero, Types::Coercible::String
      attribute :barCode, Types::Coercible::String
    end
  end