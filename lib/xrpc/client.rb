require "httparty"
require "json"

module XRPC
  class << self
    def client(url)
      XRPC::Client.new(url)
    end
  end

  class Client
    attr_accessor :headers, :token

    def initialize(base_url, token = nil)
      @token = token
      @headers = { :"Content-Type" => "application/json", :Authorization => "Bearer #{@token}" }
      @base_url = base_url
    end

    def headers!
      @headers = { :"Content-Type" => "application/json", :Authorization => "Bearer #{@token}" }
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
        self.class.base_uri base_url
        @headers = headers
      end

      def method_missing(method_name, **params)
        self.class.get("/xrpc/#{method_name.to_s.gsub("_", ".")}", query: params, headers: @headers).then do |response|
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
