module Asaas
  module Api
    class Base

      attr_reader :endpoint
      attr_reader :meta
      attr_reader :errors
      attr_reader :success
      attr_reader :token
      attr_accessor :route

      def initialize(client_token, api_version, route = nil)
        @token    = client_token
        @route    = route
        @api_version = api_version || Asaas::Configuration.api_version
        @endpoint = Asaas::Configuration.get_endpoint(api_version)
      end

      def extract_meta(meta)
        @meta = Asaas::Entity::Meta.new(meta)
      end

      def get(id)
        request(:get, {id: id})
      end

      def list(params = {})
        request(:get, params)
      end

      def create(attrs)
        request(:post, {}, attrs)
      end

      def update(attrs)
        request(:post, {id: attrs.id}, attrs)
      end

      def delete(id)
        request(:delete, {id: id})
      end

      protected
      def parse_url(id = nil, path = nil)
        u = URI(@endpoint + @route)
        u.path += "/#{path}" if path
        u.path += "/#{id}" if id
        u.to_s
      end

      def child_request(method, path)
        request(method, {}, nil, path)
      end

      def request(method, params = {}, body = nil, path = nil)
        body = body.to_h
        body = body.delete_if { |k, v| v.nil? || v.to_s.empty? }
        body = body.to_json
        puts body if Asaas::Configuration.debug
        @response = Typhoeus::Request.new(
            parse_url(params.fetch(:id, false), path),
            method: method,
            body: body,
            params: params,
            headers: {
              'access_token': @token || Asaas::Configuration.token,
              'Content-Type': 'application/json'
             },
            verbose: Asaas::Configuration.debug
        ).run
        parse_response
      end

      def parse_response
        response_code =  @response.response_code
        puts "Response status: #{response_code}" if Asaas::Configuration.debug
        case response_code
        when 200
          res = response_success
        when 400
          response_bad_request
        when 401
          raise Asaas::Api::Error.new('invalid_token', 'The api_key is invalid')
        when 500
          raise Asaas::Api::Error.new('internal_server_error', 'Internal Server Error')
        else
          raise Asaas::Api::Error.new('not_found', 'Object not found')
        end
        res
      end

      def response_success
        entity = nil
        hash = JSON.parse(@response.body)
        puts hash if Asaas::Configuration.debug
        Hashie::Mash.new(hash)
      end

      def response_bad_request
        details = []
        begin
          hash = JSON.parse(@response.body)
          errors = hash.fetch("errors", [])
          errors.each do |item|
            details << item
          end
          error
        rescue
          #ignore
        end
        raise Asaas::Api::Error.new('bad_request', 'Bad request', details)
      end

      def get_headers
        { 'access_token': @token || Asaas::Configuration.token }
      end
    end
  end
end
