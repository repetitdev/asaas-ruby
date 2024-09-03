module Asaas
  module Api
    class PaymentLink < Asaas::Api::Base
      def initialize(token, api_version)
        super(token, api_version, '/paymentLinks')
      end

    end
  end
end
