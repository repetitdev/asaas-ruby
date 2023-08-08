module Asaas
    module Api
      class MyAccount < Asaas::Api::Base
  
        def initialize(token, api_version)
          super(token, api_version, '/myAccount')
        end
  
        def documents
          child_request(:get, "documents")
          parse_response("documents")
        end
  
      end
    end
  end