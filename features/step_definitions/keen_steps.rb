begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
require 'cucumber/formatter/unicode'
$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'keen'

Given /^a Keen Client in Direct Send mode$/ do
  @client = Keen::Client.new(@project_id, 
                             @api_key, 
                             :cache_locally => false,
                             :logging => false )
end

When /^I post an event$/ do
  @result = @client.add_event("cucumber_events", {:hi_from => "cucumber!", :keen_version => Keen::VERSION})
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
