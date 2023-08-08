module Asaas
  class DocumentRequest < Model

    Status = Types::Strict::String.enum('NOT_SENT', 'PENDING', 'APPROVED', 'REJECTED')

    attribute :id, Types::Coercible::String.optional.default(nil)
    attribute :status, Status.optional.default(nil)
    attribute :type, Types::Coercible::String.optional.default(nil)
    attribute :title, Types::Coercible::String.optional.default(nil)
    attribute :description, Types::Coercible::String.optional.default(nil)
    attribute :responsible, Types::Array.of(DocumentResponsible).optional.default([])
    attribute :onboardingUrl, Types::Coercible::String.optional.default(nil)
    attribute :documents, Types::Array.of(DocumentFile).optional.default([])

  end
end
