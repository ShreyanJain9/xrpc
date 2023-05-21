require "json"
require "rack"

module XRPC
  class Server
    def initialize(lexicons)
      @lexicons = lexicons
    end

    def method(id)
      # endpoint = find_endpoint(id)
      # raise ArgumentError, "Endpoint '#{id}' not found" unless endpoint

      define_singleton_method(id) do |input, **params|
        endpoint.call(input, params)
      end
    end

    def decode_params(nsid, query_params)
      #  logic to decode query parameters based on nsid
      # For simplicity, let's assume no decoding is needed and return the query params as is
      query_params
    end

    def call(nsid, input, **params)
      endpoint = find_endpoint(nsid)
      raise ArgumentError, "Endpoint '#{nsid}' not found" unless endpoint

      endpoint.call(input, params)
    end

    private

    def find_endpoint(id)
      @lexicons.each do |lexicon|
        endpoint = lexicon.endpoint(id)
        return endpoint if endpoint
      end

      nil
    end
  end
end
