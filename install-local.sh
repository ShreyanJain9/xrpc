#!/bin/bash

# get the current version from lib/xrpc/version.rb
VERSION=`cat lib/xrpc/version.rb | grep "VERSION =" | cut -d '"' -f 2`
echo "Building gem version $VERSION"

# build the gem
gem build xrpc.gemspec

# install the gem locally
gem install ./xrpc-$VERSION.gem
