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
        res =  @response.response_code
        puts "Response status: #{res}" if Asaas::Configuration.debug
        case @response.response_code
          when 200
            res = response_success
          when 400
            res = response_bad_request
          when 401
            res = response_unauthorized
          when 404
            res = response_not_found
          when 500
            res = response_internal_server_error
          else
            res = response_not_found
        end
        res
      end

      def response_success
        entity = nil
        hash = JSON.parse(@response.body)
        puts hash if Asaas::Configuration.debug
        Hashie::Mash.new(hash)
      end

      def response_unauthorized
        error = Asaas::Entity::Error.new
        error.errors << Asaas::Entity::ErrorItem.new(code: 'invalid_token', description: 'The api_key is invalid')
        error
      end

      def response_internal_server_error
        error = Asaas::Entity::Error.new
        error.errors << Asaas::Entity::ErrorItem.new(code: 'internal_server_error', description: 'Internal Server Error')
        error
      end

      def response_not_found
        error = Asaas::Entity::Error.new
        error.errors << Asaas::Entity::ErrorItem.new(code: 'not_found', description: 'Object not found')
        error
      end

      def response_bad_request
        error = Asaas::Entity::Error.new
        begin
          hash = JSON.parse(@response.body)
          errors = hash.fetch("errors", [])
          errors.each do |item|
            error.errors << Asaas::Entity::ErrorItem.new(item)
          end
          error
        rescue
          error = Asaas::Entity::Error.new
          error.errors << Asaas::Entity::ErrorItem.new(code: 'bad_request', description: 'Bad Request')
          error
        end
        error
      end

      def get_headers
        { 'access_token': @token || Asaas::Configuration.token }
      end
    end
  end
end
