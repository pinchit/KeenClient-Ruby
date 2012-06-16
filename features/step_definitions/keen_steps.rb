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

  @starting_queue_size = @client.storage_handler.count_active_queue
end

Given /^a Keen Client using Direct$/ do
  @client = Keen::Client.new(@project_id, 
                             @auth_token, 
                             :cache_locally => false,
                             :logging => false )
end

When /^I post an event$/ do
  @result = @client.add_event("cucumber_events", {:hi_from => :cucumber, :keen_version => Keen::VERSION})
end

Then /^the size of the Redis queue should have gone up by one\.$/ do
  @client.storage_handler.count_active_queue.should == 1 + @starting_queue_size
end

Then /^the response from the server should be good\.$/ do
  response = @result
  response.should == {"created" => true}
end
