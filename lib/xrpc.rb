require "uri"
require "httparty"
require "json"

module XRPC
  class Service
    def initialize(pds)
      @pds = pds
    end

    def call(endpoint, params = {}, body = nil)
      endpoint_uri = URI("#{@pds}/xrpc/#{endpoint}?#{URI.encode_www_form(params)}")
      headers = { 'Content-Type': "application/json" }

      response = if body
          HTTParty.post(endpoint_uri, body: body.to_json, headers: headers)
        else
          HTTParty.get(endpoint_uri)
        end

      { encoding: response.headers["Content-Type"], body: JSON.parse(response.body) }
    end
  end
end

module XRPC
  class Endpoint
    attr_reader :id, :lexicon

    def initialize(id, lexicon)
      @id = id
      @lexicon = lexicon
    end

    def call(service, params = {}, body = nil)
      service.call(@id, params, body)
    end
  end
end

module XRPC
  class Lexicon
    def initialize(lexicon)
      @lexicon = lexicon
    end

    def endpoint(id)
      Endpoint.new(id, @lexicon)
    end
  end
end

module XRPC
  class Client
    def initialize
      @lexicons = []
    end

    def add_lexicon(lexicon)
      @lexicons << Lexicon.new(lexicon)
    end

    def service(pds)
      Service.new(pds)
    end

    def endpoint(id)
      @lexicons.each do |lexicon|
        endpoint = lexicon.endpoint(id)
        return endpoint if endpoint

        nil
      end
    end
  end
end

# # example usage
# client = XRPC::Client.new

# client.add_lexicon({
#   lexicon: 1,
#   id: 'io.example.ping',
#   defs: {
#     main: {
#       type: 'query',
#       description: 'Ping the server',
#       parameters: {
#         type: 'params',
#         properties: { message: { type: 'string' } }
#       },
#       output: {
#         encoding: 'application/json',
#         schema: {
#           type: 'object',
#           required: ['message'],
#           properties: { message: { type: 'string' } }
#         }
#       }
#     }
#   }
# })

# client.add_lexicon({
#   lexicon: 1,
#   id: 'io.example.writeJsonFile',
#   defs: {
#     main: {
#       type: 'procedure',
#       description: 'Write a JSON file',
#       parameters: {
#         type: 'params',
#         properties: { fileName: { type: 'string' } }
#       },
#       input: {
#         encoding: 'application/json'
#       }
#     }
#   }
# })

# # call endpoint with query parameters and input body
# res1 = client.service('https://example.com').call('io.example.writeJsonFile', { fileName: 'foo.json' }, { hello: 'world', thisIs: 'the file to write' })
# puts res1
# # => { encoding: 'application/json', body: nil }

# # call endpoint with query parameters only
# res2 = client.endpoint('io.example.ping').call(client.service('https://example.com'), { message: 'hello world' })
# puts res2
# # => { encoding: 'application/json', body: { message: 'hello world' } }
