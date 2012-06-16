require "keen/async/storage/redis_handler"


module Keen

  module Async

    # How many events should we send over the wire at a time?
    BATCH_SIZE = 100
    SSL_CA_FILE = File.dirname(__FILE__) + '../../../conf/cacert.pem'
     
    class Worker

      def initialize(client)
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

        num_batches = 1 + queue_length / batch_size

        num_batches.times do
          collated = @storage_handler.get_collated_jobs(batch_size)
          collated.each do |project_id, batch|
            send_batch(project_id, batch)
          end
        end

        return "Worker sent #{num_batches} batches of #{batch_size} events per batch."
      end

      def send_batch(project_id, batch)
        if not batch
          return
        end

        auth_token = job_list[0].auth_token

        # TODO: If something fails, we should move the job to the 
        # prior_failures queue by calling, perhaps:
        #
        # @handler.log_failed_job(job)
      end

    end
  end

end
