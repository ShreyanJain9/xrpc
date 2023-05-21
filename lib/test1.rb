require "json"
require "sinatra"
require_relative "xrpc/server"

# Define your Sinatra application
class MyApp < Sinatra::Base
  before do
    content_type :json
    lexicons = [{
      "lexicon": 1,
      "id": "com.atproto.identity.resolveHandle",
      "defs": {
        "main": {
          "type": "query",
          "description": "Provides the DID of a repo.",
          "parameters": {
            "type": "params",
            "properties": {
              "handle": {
                "type": "string",
                "format": "handle",
                "description": "The handle to resolve. If not supplied, will resolve the host's own handle.",
              },
            },
          },
          "output": {
            "encoding": "application/json",
            "schema": {
              "type": "object",
              "required": [
                "did",
              ],
              "properties": {
                "did": {
                  "type": "string",
                  "format": "did",
                },
              },
            },
          },
        },
      },
    }]
    @server = XRPC::Server.new(lexicons)

    # Define your XRPC endpoints using the server's method
    @server.method("com.example.my-query") do |input, **params|
      output = { "foo" => input["foo"], "b" => params["param_a"] + 1 }
      output
    end
  end

  post "/xrpc/*" do
    nsid = params[:splat].first
    input = JSON.parse(request.body.read)
    params = @server.decode_params(nsid, params)
    output = @server.call(nsid, input, **params)
    output.to_json
  end
end

# Run the Sinatra application
MyApp.run!
