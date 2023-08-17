require 'faraday'
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
        request(method: :get, path: make_path(id))
      end

      def list(params = {})
        request(method: :get, params: params)
      end

      def create(attrs)
        request(method: :post, params: attrs)
      end

      def update(attrs)
        request(method: :post, path: make_path(id), params: attrs)
      end

      def delete(id)
        request(method: :delete, path: make_path(id))
      end

      protected
      def parse_url
        u = URI(@endpoint + @route)
        puts u.to_s
        u.to_s
      end

      def make_path(id = nil, path = nil)
        return "#{path}" if path
        return "#{id}" if id
      end

      def child_request(method, path, params = {})
        
        request(method: method, params: params, path: make_path(nil, path))
      end

      def request(method:, params: {}, path: nil)
        body = body.to_h
        body = body.delete_if { |k, v| v.nil? || v.to_s.empty? }
        body = body.to_json
        puts body if Asaas::Configuration.debug
        
        logger = Logger.new $stderr
        logger.level = Logger::DEBUG

        conn = Faraday.new(
          url: parse_url, 
          headers: {
            'access_token': @token || Asaas::Configuration.token,
            'Content-Type': 'application/json;charset=utf-8',
            'User-Agent': 'PostmanRuntime/7.32.3',
            'Connection': 'keep-alive',
            'Accept': '*/*',
            'Accept-Encoding': 'gzip, deflate, br',
            'Cache-Control': 'no-cache'
           }
        ) do |conn|
          conn.response :logger, logger
          conn.response :json
          conn.request :json
        end
        
        case method
        when :get
          @response = conn.get(path, params)
        when :put
          @response = conn.put(path, params)
        when :post
          @response = conn.post(path, params)
        when :delete
          @response = conn.post(path, params)
        end
        parse_response
      end

      def parse_response
        response_code =  @response.status
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
        puts hash if Asaas::Configuration.debug
        Hashie::Mash.new(@response.body)
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
