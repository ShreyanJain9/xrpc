require "httparty"
require "json"

module XRPC
  class << self
    def client(url)
      XRPC::Client.new(url)
    end
  end

  class Client
    attr_reader :get, :post

    def initialize(base_url)
      @base_url = base_url
      @get = GetRequest.new(base_url)
      @post = PostRequest.new(base_url)
    end

    class GetRequest
      include HTTParty

      def initialize(base_url)
        self.class.base_uri base_url
      end

      def method_missing(method_name, **params)
        JSON.parse self.class.get("/xrpc/#{method_name.to_s.gsub("_", ".")}", query: params).body
      end
    end

    class PostRequest
      include HTTParty

      def initialize(base_url)
        self.class.base_uri base_url
      end

      def method_missing(method_name, **params)
        JSON.parse self.class.post("/xrpc/#{method_name.to_s.gsub("_", ".")}", body: params).body
      end
    end
  end
end
