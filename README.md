# XRPC

This Gem provides the ability to use BlueSky's XRPC from Ruby! :)

It's designed for use as a part of Bskyrb, but can be used independently, since there's nothing Bskyrb-specific in it.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add xrpc

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install xrpc

## What is XRPC?

XRPC is a powerful tool for server-to-server messaging that can be used for a variety of purposes. One of its main benefits is that it provides a consistent communication layer for data layer and social applications. This means that messages can be sent between different services, even if they have different underlying technologies.

XRPC uses HTTP/S for transport, and supports both client-to-server and server-to-server messaging. Each user has a Personal Data Server (PDS) that acts as their agent in the network, and most communication is routed through this PDS.

XRPC "Methods" are defined using schemas that specify the accepted inputs and outputs. These schemas are globally identified and published as machine-readable documents to ensure consistency across the network. XRPC supports structured data in JSON format as well as unstructured binary blobs.

Method IDs are identified using NSIDs, which are a form of Reverse Domain-Name Notation. Method schemas are encoded in JSON using Lexicon Schema Documents, which are designed to be machine-readable and network-accessible. It is recommended to publish schemas so that a single canonical and authoritative representation is available to consumers of the method.

To fetch a schema, a request must be sent to the built-in getSchema method, which is sent to the authority of the NSID. Requests are sent to the /xrpc/{methodId} path on the target server, with parameters encoded as query parameters using the encodeParam function. If a default value is specified in the method schema, it should be included in requests to ensure consistent caching behaviors.

XRPC also supports schema versioning and extensibility, which allows for future updates and modifications to the protocol without breaking existing implementations.

(ChatGPTed from the AT Protocol docs)

To read more, go to https://atproto.com/specs/xrpc.

## Usage

The below is an example of how to use this XRPC Ruby library to resolve BlueSky handles to DIDs.

```ruby
bluesky = XRPC::Client.new("https://bsky.social")
bluesky.get.com_atproto_identity_resolveHandle(handle: "shreyan.bsky.social")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bash ./install-local.sh`. To release a new version, run `bash ./deploy.sh`, which will update the version number in `version.rb` and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ShreyanJain9/xrpc. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ShreyanJain9/xrpc/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in Bskyrb codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ShreyanJain9/xrpc/blob/master/CODE_OF_CONDUCT.md).
