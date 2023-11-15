# XRPC

This Gem provides the ability to use BlueSky's XRPC from Ruby! :)

It's designed for use as a part of Bskyrb, but can be used independently, since there's nothing Bskyrb-specific in it.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add xrpc

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install xrpc

## What is XRPC?

Learn at the [AT Protocol docs](https://atproto.com/specs/xrpc).

## Usage

The below is an example of how to use this XRPC Ruby library to resolve BlueSky handles to DIDs.

```ruby
bluesky = XRPC::Client.new("https://bsky.social")
bluesky.get.com.atproto.identity.resolveHandle[handle: "shreyan.bsky.social"] 
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
