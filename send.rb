require "rubygems"
require "keen"

storage_handler = Keen::Client.create_new_storage_handler(:redis)

count = storage_handler.count_active_queue
puts "we have this many jobs: #{count}"

worker = Keen::Async::Worker.new(storage_handler)
results = worker.process_queue

puts results
