module Keen
  class Event

    attr_accessor :event_collection, :properties, :timestamp

    def initialize(event_collection, properties, timestamp=nil)
      @event_collection = event_collection
      @properties = properties
      @timestamp = timestamp
    end

  end
end
