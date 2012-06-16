$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "lib")

require "keen"

describe Keen::Client do

  # The add_event method should add stuff to Redis:
  describe "#add_event" do

    # set up the Keen Client instance:
    project_id = "4f5775ad163d666a6100000e"
    auth_token = "a5d4eaf432914823a94ecd7e0cb547b9"

    # Make a client:
    client = Keen::Client.new(project_id, 
                              auth_token, 
                              :storage_class => Keen::Async::Storage::RedisHandler,
                              :logging => true )

    # Flush the queue first:
    client.clear_active_queue()

    # Send some events to the client, which should persist them in Redis
    5.times do
      client.add_event("rspec_clicks", {
        :hi => "you",
      })
    end

    # Make sure we have the right number of things in the queue:
    client.storage_handler.count_active_queue.should == 5

  end
end
