require "httparty"
require "json"

module XRPC
  class << self
    def client(url)
      XRPC::Client.new(url)
    end
  end

  class Client
    attr_accessor :headers
    attr_reader :token, :base_url

    def initialize(base_url, token = nil)
      @token = token
      @headers = { :"Content-Type" => "application/json", :Authorization => "Bearer #{@token}" }
      @base_url = base_url
    end

    def headers!
      @headers[:Authorization] = "Bearer #{@token}"
    end

    def token=(token)
      @token = token
      headers!
    end

    def get
      GetRequest.new(base_url, @headers)
    end

    def post
      PostRequest.new(base_url, @headers)
    end

    def inspect
      "XRPC::Client(\"#{@base_url}\")"
    end

    class GetRequest
      include HTTParty

      def initialize(base_url, headers)
        @base_uri = base_url
        @headers = headers
      end

      def method_missing(method_name, **params)
        return XRPC::Endpoint.new(self, method_name.to_s, :get) if method_name.to_s.gsub("_", ".") == method_name.to_s
        self.class.get("#{@base_uri}/xrpc/#{method_name.to_s.gsub("_", ".")}", query: params, headers: @headers).then do |response|
          response.body.empty? ? response.code : JSON.parse(response.body)
        end
      end
    end

    class PostRequest
      include HTTParty

      def initialize(base_url, headers)
        self.class.base_uri base_url
        @headers = headers
      end

      def method_missing(method_name, **params)
        self.class.post("/xrpc/#{method_name.to_s.gsub("_", ".")}", body: params.to_json, headers: @headers).then do |response|
          response.body.empty? ? response.code : JSON.parse(response.body)
        end
      end
    end
  end
end

module XRPC
  class Endpoint < Struct.new(:client, :lexicon, :type)
    def call(**kwargs)
      client.send(lexicon.gsub(".", "_"), **kwargs)
    end

    alias_method :[], :call

    def to_proc
      method(:call).to_proc
    end

    def |(hash)
      call(**hash)
    end

    def method_missing(method_name, **kwargs)
      Endpoint.new(client, "#{lexicon}.#{method_name}", type)
    end
  end
end
