module Asaas
  module Api
    class Installment < Asaas::Api::Base
      def initialize(token, api_version)
        super(token, api_version, '/installments')
      end
      
      def refund(id, params)
        child_request(:post, "#{id}/refund", params)
      end

    end
  end
end
