module Asaas
  module Api
    class Error < StandardError
      attr_accessor :code, :details

      def initialize(code, message, details = nil)
        super(message)
        @code = code
        @details = details
      end

    end
  end
end