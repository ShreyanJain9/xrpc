lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "xrpc/version"

specfiles = Dir["./lib/xrpc/*"]
specfiles.push("./lib/xrpc.rb")

Gem::Specification.new do |spec|
  spec.name = "xrpc"
  spec.version = XRPC::VERSION
  spec.authors = ["Shreyan Jain"]
  spec.email = ["shreyan.jain.9@outlook.com"]
  spec.description = "A Ruby gem for interacting with bsky/atproto"
  spec.summary = "Interact with bsky/atproto using Ruby"
  spec.homepage = "https://github.com/ShreyanJain9/xrpc"
  spec.license = "MIT"
  spec.files = specfiles
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "json", ">= 2.0"
  spec.add_runtime_dependency "date"
  spec.add_runtime_dependency "httparty"
end
