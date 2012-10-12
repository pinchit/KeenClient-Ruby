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

        def clear_active_queue
          redis.del active_queue_key
        end

        def get_authorized_jobs(how_many, client)

          handle_prior_failures

          key = active_queue_key

          job_definitions = []
          skipped_job_definitions = []

          #puts "doing the job #{how_many} times"

          while true do
            this = redis.lpop key

            # If we're out of jobs, end the loop:
            if not this
              break
            end
            
            # Parse the JSON into a job definition
            job_definition = JSON.parse this
            job_definition = Keen::Utils.symbolize_keys(job_definition)

            # Make sure this client is authorized to process this job:
            unless job_definition[:project_id] == client.project_id
              unless job_definition[:api_key] == client.api_key
                # We're not authorized, so skip this job.
                skipped_job_definitions.push job_definition
                next
              end
            end

            job_definitions.push job_definition

            if job_definitions.length == how_many
              break
            end

          end

          # Put the skipped jobs back on the queue.
          skipped_job_definitions.each do |job_definition|
            redis.lpush key, job_definition
          end

          job_definitions

        end

      end
    end
  end
end
