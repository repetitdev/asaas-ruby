module Asaas
  module Api
    class Payment < Asaas::Api::Base

      def initialize(token, api_version)
        super(token, api_version, '/payments')
      end

      def pix_qr_code(id)
        child_request(:get, "#{id}/pixQrCode")
      end

      def identification_field(id)
        child_request(:get, "#{id}/identificationField")
      end

      def refund(id, params)
        child_request(:post, "#{id}/refund", params)
      end

    end
  end
end
