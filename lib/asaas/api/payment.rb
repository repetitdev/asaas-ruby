module Asaas
  module Api
    class Payment < Asaas::Api::Base

      def initialize(token, api_version)
        super(token, api_version, '/payments')
      end

      def pix_qr_code(id)
        child_request(:get, "#{id}/pixQrCode")
        parse_response("pix_qr_code")
      end

      def identification_field(id)
        child_request(:get, "#{id}/identificationField")
        parse_response("identification_field")
      end

    end
  end
end