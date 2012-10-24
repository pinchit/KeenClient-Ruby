require "json"
require "uri"
require "time"
require "net/http"
require "net/https"


module Keen
  class Client
    attr_accessor :project_id, :api_key, :options, :logging

    def base_url
      if @options[:base_url]
        @options[:base_url]
      else
        "https://api.keen.io/3.0"
      end
    end

    def ssl_cert_file
      File.expand_path("../../conf/cacert.pem", __FILE__)
    end

    def initialize(project_id, api_key, options = {})
      raise "project_id must be string" unless project_id.kind_of? String
      raise "api_key must be string" unless api_key.kind_of? String

      default_options = {
        :logging => true,
      }

      options = default_options.update(options)

      @project_id = project_id
      @api_key = api_key

      @logging = options[:logging]
      @options = options
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
      http.ca_file = ssl_cert_file
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

    def validate_event_collection(event_collection)
      # TODO
    end
  end
end
