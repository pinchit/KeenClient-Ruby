require 'fileutils'
require 'redis'
require 'json'
require 'time'

module Keen
  module Async
    module Storage
      class RedisHandler < Keen::Async::Storage::BaseStorageHandler

        # Keys
        # ----

        def add_to_active_queue(value)
          redis.lpush active_queue_key, value
          if @logging
            puts "added #{value} to active queue; length is now #{redis.llen active_queue_key}"
          end
        end

        def redis
          unless @redis
            @redis = Redis.new
          end
          
          @redis
        end

        def count_active_queue
          redis.llen active_queue_key
        end

        def get_collated_jobs(how_many)

          handle_prior_failures

          key = active_queue_key

          jobs = []

          #puts "doing the job #{how_many} times"

          how_many.times do
            this = redis.lpop key
            if this
              jobs.push JSON.parse this
            else
              #puts "couldn't process value #{this}"
            end
          end

          collate_jobs(jobs)
        end

      end
    end
  end
end
