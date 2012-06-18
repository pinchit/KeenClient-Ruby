require "json"
require "uri"
require "time"
require "net/http"
require "net/https"


module Keen

  class Client

    attr_accessor :storage_handler, :project_id, :auth_token, :options

    def base_url
      if @options[:base_url]
        @options[:base_url]
      else
        "https://api.keen.io/2.0"
      end
    end

    def initialize(project_id, auth_token, options = {})

      raise "project_id must be string" unless project_id.kind_of? String
      raise "auth_token must be string" unless auth_token.kind_of? String

      default_options = {
        :logging => true,
        
        # warning! not caching locally leads to bad performance:
        :cache_locally => true, 

        # this is required if cache_locally is true:
        :storage_class => nil, 

        # all keys will be prepended with this:
        :storage_namespace => "default",
      }

      options = default_options.update(options)

      @project_id = project_id
      @auth_token = auth_token
      @cache_locally = options[:cache_locally]

      if @cache_locally
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

    def add_event(collection_name, event_body, timestamp=nil)
      #
      # `collection_name` should be a string
      #
      # `event_body` should be a JSON-serializable hash
      #
      # `timestamp` is optional. If sent, it should be a Time instance.  
      #  If it's not sent, we'll use the current time.
      
      validate_collection_name(collection_name)

      unless timestamp
        timestamp = Time.now
      end

      timestamp = timestamp.utc.iso8601

      event = Keen::Event.new(timestamp, collection_name, event_body)

      if @cache_locally
        job = Keen::Async::Job.new(storage_handler, {
          :timestamp => event.timestamp,
          :project_id => @project_id,
          :auth_token => @auth_token,
          :collection_name => collection_name,
          :event_body => event.body,
        })

        job.save
      else
        # build the request:
        url = "#{base_url}/projects/#{project_id}/#{collection_name}"
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.ca_file = Keen::Async::SSL_CA_FILE
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        http.verify_depth = 5

        request = Net::HTTP::Post.new(uri.path)
        request.body = JSON.generate({
          :header => {
            :timestamp => event.timestamp,
          },
          :body => event.body
        })

        request["Content-Type"] = "application/json"
        request["Authorization"] = @auth_token

        response = http.request(request)
        JSON.parse response.body
      end
    end

    def send_batch(events)
      # make the request body:
      request_body = {}
      events.each { |event| 
        unless request_body.has_key? event.collection_name
          request_body[event.collection_name] = []
        end

        header = {"timestamp" => event.timestamp}
        body = event.body
        item = {"header" => header, "body" => body}
        request_body[event.collection_name].push(item)
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
      request["Authorization"] = auth_token

      resp = http.request(request)

      return JSON.parse resp.body

    end

    def validate_collection_name(collection_name)
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
