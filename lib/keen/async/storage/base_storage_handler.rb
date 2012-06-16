require 'json'
require 'time'

module Keen
  module Async
    module Storage
      class BaseStorageHandler

        def initialize(client)
          @logging = client.options[:logging]
          @client = client
        end

        # Key stuff
        # ----

        def global_key_prefix
          "keen.#{@client.options[:storage_namespace]}"
        end
        
        def active_queue_key
          "#{global_key_prefix}.active_queue"
        end

        def failed_queue_key
          "#{global_key_prefix}.failed_queue"
        end

        def add_to_active_queue(value)
          @redis.lpush active_queue_key, value
          if @logging
            puts "added #{value} to active queue; length is now #{@redis.llen active_queue_key}"
          end
        end

        def record_job(job)
          add_to_active_queue JSON.generate(job)
        end

        def handle_prior_failures
          # TODO consume the failed_queue and do something with it (loggly? retry? flat file?)
        end

        def count_active_queue
          raise NotImplementedError
        end

      end
    end
  end
end
