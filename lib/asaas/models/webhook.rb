module Asaas
  class Webhook < Model
    attribute :id, Types::Coercible::String.optional.default(nil)
    attribute :url, Types::Coercible::String.optional.default { Asaas::Configuration.webhook_url }
    attribute :email, Types::Coercible::String.optional.default { Asaas::Configuration.webhook_email }
    attribute :apiVersion, Types::Coercible::Integer.optional.default { Asaas::Configuration.api_version }
    attribute :enabled, Types::Bool.optional.default(nil)
    attribute :interrupted, Types::Bool.optional.default(nil)
    attribute :authToken, Types::Coercible::String.optional.default { Asaas::Configuration.webhook_auth_token }
    attribute :type, Types::Coercible::String.optional
  end
end