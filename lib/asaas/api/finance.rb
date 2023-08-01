module Asaas
  module Api
    class Finance < Asaas::Api::Base

      def initialize(token, api_version)
        super(token, api_version, '/finance')
      end

      def balance
        request(:get, {id: "balance"})
        parse_response("balance")
      end

    end
  end
end