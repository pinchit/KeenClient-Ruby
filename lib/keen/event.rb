module Keen
  class Event

    attr_accessor :timestamp, :collection_name, :body

    def initialize(timestamp, collection_name, body)
      @timestamp = timestamp
      @collection_name = collection_name
      @body = body
    end

  end
end
