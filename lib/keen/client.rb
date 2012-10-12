require "json"
require "uri"
require "time"
require "net/http"
require "net/https"


module Keen

  class Client

    attr_accessor :storage_handler, :project_id, :api_key, :options, :logging

    def base_url
      if @options[:base_url]
        @options[:base_url]
      else
        "https://api.keen.io/3.0"
      end
    end

    def initialize(project_id, api_key, options = {})

      raise "project_id must be string" unless project_id.kind_of? String
      raise "api_key must be string" unless api_key.kind_of? String

      default_options = {
        :logging => true,
        
        # should we cache events locally somewhere?  if false, sends directly to Keen
        :cache_locally => false, 

        # this is required if cache_locally is true:
        :storage_class => nil, 

        # all keys will be prepended with this:
        :storage_namespace => "default",
      }

      options = default_options.update(options)

      @project_id = project_id
      @api_key = api_key
      @cache_locally = options[:cache_locally]

      if @cache_locally
        raise "Local caching not supported in this version."

        @storage_class = options[:storage_class]
        unless @storage_class and @storage_class < Keen::Async::Storage::BaseStorageHandler
          raise "The Storage Class you send must extend BaseStorageHandler.  You sent: #{@storage_class}"
        end
      end

      @logging = options[:logging]
      @options = options

    end

    def storage_handler
      unless @storage_handler
        @storage_handler = @storage_class.new(self)
      end

      @storage_handler
    end

    def add_event(event_collection, event_properties, timestamp=nil)
      #
      # `event_collection` should be a string
      #
      # `event` should be a JSON-serializable hash
      #
      # `timestamp` is optional. If sent, it should be a Time instance.  
      #  If it's not sent, we'll use the current time.
      
      validate_event_collection(event_collection)

      if timestamp
        timestamp = timestamp.utc.iso8601
      end

      event = Keen::Event.new(event_collection, event_properties)

      # build the request:
      url = "#{base_url}/projects/#{project_id}/events/#{event_collection}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.ca_file = Keen::Async::SSL_CA_FILE
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.verify_depth = 5

      request = Net::HTTP::Post.new(uri.path)

      body = event.properties

      if timestamp
        request.body[:keen] = {
          :timestamp => timestamp
        }
      end

      request.body = JSON.generate(body)

      request["Content-Type"] = "application/json"
      request["Authorization"] = @api_key

      response = http.request(request)
      JSON.parse response.body

    end

    def send_batch(events)
      # make the request body:
      request_body = {}
      events.each { |event| 
        unless request_body.has_key? event.event_collection
          request_body[event.event_collection] = []
        end

        header = {"timestamp" => event.timestamp}
        body = event.body
        item = {"header" => header, "body" => body}
        request_body[event.event_collection].push(item)
      }
      request_body = request_body.to_json
    
      # build the request:
      url = "#{base_url}/projects/#{project_id}/_events"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.ca_file = Keen::Async::SSL_CA_FILE
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.verify_depth = 5

      request = Net::HTTP::Post.new(uri.path)
      request.body = request_body
      request["Content-Type"] = "application/json"
      request["Authorization"] = api_key

      resp = http.request(request)

      if @logging
        puts resp.body
      end

      return JSON.parse resp.body
    end

    def validate_event_collection(event_collection)
      # TODO
    end

    def self.create_new_storage_handler(storage_mode, client, logging)
      # This is shitty as hell.  We shoudl take in a class reference pointing to the storage handler, not switch on string values
      case storage_mode.to_sym

      when :redis
        Keen::Async::Storage::RedisHandler.new(client, logging)
      else
        raise "Unknown storage_mode sent to client: `#{storage_mode}`"
      end
    end

  end
end
