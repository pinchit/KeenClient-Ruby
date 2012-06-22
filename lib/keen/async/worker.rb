require "keen/async/storage/redis_handler"


module Keen

  module Async

    # How many events should we send over the wire at a time?
    BATCH_SIZE = 100
    SSL_CA_FILE = File.dirname(__FILE__) + '../../../conf/cacert.pem'
     
    class Worker

      def initialize(client)
        @client = client
        @storage_handler = client.storage_handler
      end

      def batch_url(project_id)
        if not project_id
          raise "Missing project_id."
        end
        "https://api.keen.io/2.0/projects/#{project_id}/_events"
      end

      def process_queue
        queue_length = @storage_handler.count_active_queue

        batch_size = Keen::Async::BATCH_SIZE


        events = []


        responses = []

        num_batches = queue_length / batch_size + 1
        num_batches.times do

          job_definitions = @storage_handler.get_authorized_jobs(batch_size, @client)

          job_definitions.each do |job_definition|
            #puts JSON.generate job_definition
            job = Keen::Async::Job.new(@client, job_definition)
            events.push Keen::Event.new(job.timestamp, job.collection_name, job.event_body)
          end

          responses.push @client.send_batch(events)
        end

        if @client.logging
          puts responses
        end

        responses

      end

    end
  end

end
