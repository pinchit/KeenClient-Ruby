begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
require 'cucumber/formatter/unicode'
$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'keen'

Given /^a Keen Client using Redis$/ do
  @client = Keen::Client.new(@project_id, 
                             @auth_token, 
                             :storage_class => Keen::Async::Storage::RedisHandler,
                             :storage_namespace => "test",
                             :logging => false )

  @client.storage_handler.clear_active_queue

  @starting_queue_size = @client.storage_handler.count_active_queue
end

Given /^a Keen Client using Direct$/ do
  @client = Keen::Client.new(@project_id, 
                             @auth_token, 
                             :cache_locally => false,
                             :logging => false )
end

When /^I post an event$/ do
  @result = @client.add_event("cucumber_events", {:hi_from => "cucumber!", :keen_version => Keen::VERSION})
end

Then /^the size of the Redis queue should have gone up by (\d+)\.$/ do |n|
  @client.storage_handler.count_active_queue.should == n.to_i + @starting_queue_size
end

Then /^the response from the server should be good\.$/ do
  response = @result
  response.should == {"created" => true}
end


When /^I post (\d+) events$/ do |n|
  n.to_i.times do
    @client.add_event("cucumber_events", {:hi_from => "cucumber!", :keen_version => Keen::VERSION})
  end
end

When /^I process the queue$/ do
  worker = Keen::Async::Worker.new(@client)
  @result = worker.process_queue
end

Then /^the response from Keen should be (\d+) happy smiles$/ do |n|
  expectation = []
  n.to_i.times do
    expectation.push({"created" => true})
  end

  response = @result
  puts response.body
  response.should == expectation
end

Then /^the queue should be empty\.$/ do
  pending # express the regexp above with the code you wish you had
end
