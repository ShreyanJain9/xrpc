require "httparty"
require "json"

module XRPC
  class << self
    def client(*args) = XRPC::Client.new(*args)
  end

  class Client
    attr_accessor :headers
    attr_reader :token, :base_url

    def initialize(base_url, token = nil)
      @token = token
      @headers = { :"Content-Type" => "application/json" }
      @headers.merge! { :Authorization => "Bearer #{@token}" } if token
      @base_url = base_url
    end

    def headers! = @headers[:Authorization] = "Bearer #{@token}"

    def token=(token)
      @token = token
      headers!
    end

    def inspect = "XRPC::Client(\"#{@base_url}\")"

    class RequestType < Struct.new(:client)
      include HTTParty

      def method_missing(method_name, **params)
        return XRPC::Endpoint.new(self, method_name.to_s, :get) if method_name.to_s.gsub("_", ".") == method_name.to_s
        call(method_name, **params)
      end
    end

    class GetRequest < RequestType
      def call(method_name, **params)
        self.class.get("#{client.base_url}/xrpc/#{method_name.to_s.gsub("_", ".")}", query: params, headers: client.headers).then do |response|
          response.body.empty? ? response.code : JSON.parse(response.body)
        end
      end
    end

    class PostRequest < RequestType
      def call(method_name, **params)
        self.class.post("#{client.base_url}/xrpc/#{method_name.to_s.gsub("_", ".")}", body: params.to_json, headers: client.headers).then do |response|
          response.body.empty? ? response.code : JSON.parse(response.body)
        end
      end
    end
  end
end

module XRPC
  class Endpoint < Struct.new(:client, :lexicon, :type)
    def call(**kwargs) = client.send(lexicon.gsub(".", "_"), **kwargs)

    alias_method :[], :call

    def to_proc = method(:call).to_proc

    def |(hash) = call(**hash)

    def paginate(**kwargs, &map_block) = Pagination.new(client, lexicon, nil, **kwargs, &map_block)

    def method_missing(method_name, **kwargs) = Endpoint.new(client, "#{lexicon}.#{method_name}", type)
  end

  # Generates a lazy enumerator for paginated data retrieval.
  class Pagination

    # Parameters:
    # - session: The session object used for making API requests.
    # - method: The name of the method to be called on the session object.
    # - key: The key to access the data in the response object.
    # - params: Additional parameters to be passed in the API request.
    # - cursor: The cursor for pagination. Defaults to nil.
    # - &map_block: An optional block to transform each result.
    def initialize(client, lexicon, key, **kwargs, &map_block)
      @client, @lexicon, @key, @kwargs, @map_block = client, lexicon, key, kwargs, map_block
    end

    # Returns:
    # - A +Enumerator::Lazy+ that yields paginated data.
    def enumerator
      Enumerator.new do |yielder|
        loop do
          request_params = @kwargs.merge(limit: 100, cursor: cursor)
          response = @client.public_send(@lexicon.to_s.gsub(".", "_").to_sym, **request_params)
          @key ? data = response.dig(@key) : data = response

          if data.nil? || data.empty?
            break
          end

          if @map_block
            data = data.map(&@map_block)
          end

          data.each { |result| yielder << result }

          cursor = response.dig("cursor")
          break if cursor.nil?
        end
      end.lazy
    end
  end
end

module XRPC
  class ResponseCode < T::Enum
    enums do
      Unknown = new(1)
      InvalidResponse = new(2)
      Success = new(200)
      InvalidRequest = new(400)
      AuthRequired = new(401)
      Forbidden = new(403)
      XRPCNotSupported = new(404)
      PayloadTooLarge = new(413)
      RateLimitExceeded = new(429)
      InternalServerError = new(500)
      MethodNotImplemented = new(501)
      UpstreamFailure = new(502)
      NotEnoughResouces = new(503)
      UpstreamTimeout = new(504)
    end
  end
end

module Kernel
  def XRPC(*args) = XRPC::Client.new(*args)
end

module XRPC
  class Client
    %i(get post).each do |verb|
      requester = Object.const_get("XRPC::Client::#{verb.capitalize}Request")
      define_method(verb) do
        requester.new(self)
      end
    end
  end
end
