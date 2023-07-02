require "sinatra/base"

module Sinatra
  module XRPCRoutes
    def xrpc_get(lexicon, &block)
      # Extract the parameter names from the block's parameters
      parameters = block.parameters.map { |type, name| name.to_s }

      # Define a new route with the provided lexicon and block
      get "/xrpc/#{lexicon}" do
        content_type :json
        # Create a hash of arguments with parameter names as keys
        args = {}
        parameters.each do |param|
          args[param] = params[param] if params[param]
        end

        # Call the block with the arguments
        instance_exec(args, &block)
      end
    end

    def xrpc_post(lexicon, &block)
      # Extract the parameter names from the block's parameters
      parameters = block.parameters.map { |type, name| name.to_s }

      # Define a new route with the provided lexicon and block
      post "/xrpc/#{lexicon}" do
        content_type :json
        # Create a hash of arguments with parameter names as keys
        args = {}
        parameters.each do |param|
          args[param] = params[param] if params[param]
        end

        # Call the block with the arguments
        instance_exec(args, &block)
      end
    end
  end

  # Register the module to make it available as a macro
  register XRPCRoutes
end
