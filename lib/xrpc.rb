# typed: false
require "uri"
require "httparty"
require "json"

module XRPC
  def request(pds, endpoint_location, params)
    Endpoint.new(pds, endpoint_location).get(params)
  end

  module_function :request

  class Endpoint
    attr_reader :request_uri

    def initialize(pds, endpoint_location, authenticated: false, token: nil)
      @pds = pds
      @endpoint_location = endpoint_location
      @authenticated = authenticated
      @headers = default_headers()
      if token # Ideally, you shouldn't pass the token when creating the endpoint
        @headers = default_authenticated_headers(token)
      end
    end

    def default_headers
      { "Content-Type" => "application/json" }
    end

    def authenticated?() @authenticated end

    def default_authenticated_headers(access_token)
      default_headers.merge({
        Authorization: "Bearer #{access_token}",
      })
    end

    def authenticate(token) # This is the proper place to authenticate with a token
      # This is still a pretty weird way to authenticate, but it works (for now)
      if not @authenticated == true
        raise Error, "Non-authenticated endpoint cannot be authenticated"
      end
      @headers = default_authenticated_headers(token)
    end

    def get(params)
      query_params = URI.encode_www_form(params) # e.g. "foo=bar&baz=qux" from (foo: "bar", baz: "qux")
      @request_uri = URI("#{@pds}/xrpc/#{@endpoint_location}?#{query_params}")
      response = HTTParty.get(@request_uri, headers: @headers)
      JSON.parse(response.body)
    end
  end

  class Error < StandardError; end
end
