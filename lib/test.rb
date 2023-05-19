# example usage
client = XRPC::Client.new

client.add_lexicon({
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
})

# # call endpoint with query parameters and input body
# res1 = client.service("https://bsky.social").call("com.atproto.identity.", { fileName: "foo.json" }, { hello: "world", thisIs: "the file to write" })
# puts res1
# # => { encoding: 'application/json', body: nil }

# call endpoint with query parameters only
res2 = client.endpoint("com.atproto.identity.resolveHandle").call(client.service("https://bsky.social"), { handle: "shreyan.bsky.social" })
puts res2
# => { encoding: 'application/json', body: { message: 'hello world' } }
