module XRPC
  def self.xrpc_proc(lexicon, type, args_list, server = "https://bsky.social")
    case type
    when :query
      return XRPC::Query.new(lexicon, args_list, server)
    when :procedure
      return XRPC::Procedure.new(lexicon, args_list, server)
    else
      raise ArgumentError, "Invalid type: #{type}. Expected :query or :procedure."
    end
  end

  def self.xrpc_object_from_json(json_hash)
    json_hash[:id] ? lexicon = json_hash[:id] : lexicon = json_hash["id"]
    json_hash[:defs] ? defs = json_hash[:defs] : defs = json_hash["defs"]
    defs[:main] ? main_def = defs[:main] : main_def = defs["main"]
    main_def[:type] ? type = main_def[:type].to_sym : type = main_def["type"].to_sym
    main_def[:parameters] ? args_list = main_def[:parameters][:required] : args_list = main_def["parameters"]["required"]
    xrpc_proc(lexicon, type, args_list)
  end
end

module XRPC
  class BaseLexicon
    attr_accessor :lexicon, :args_list, :server, :headers

    def initialize(lexicon, args_list, server, headers: { "Content-Type" => "application/json" })
      @lexicon = lexicon
      @args_list = args_list
      @server = server
      @headers = headers
    end

    def call(*args, **kwargs)
      make_request(Hash[args_list.zip(args)].merge kwargs)
    end

    def make_request(payload)
      raise NotImplementedError, "Subclasses must implement the #make_request method."
    end

    def to_proc
      method(:call).to_proc
    end

    private

    def base_url
      "#{server}/xrpc/#{lexicon}"
    end
  end

  class Query < BaseLexicon
    def make_request(payload)
      HTTParty.get(base_url, query: payload, headers: headers).parsed_response
    end
  end

  class Procedure < BaseLexicon
    def make_request(payload)
      HTTParty.post(base_url, body: payload, headers: headers).parsed_response
    end
  end
end
