source "http://rubygems.org"
# Add dependencies required to use your gem here.
gem "json", ">= 1.6.5"
gem "redis"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "shoulda", ">= 0"
  gem "rdoc", "~> 3.12"
  gem "bundler", ">= 1.1.4"
  gem "jeweler", "~> 1.8.3"
  gem "rspec", ">= 2.9.0"
  gem "cucumber", ">= 1.2.1"
end

if RUBY_VERSION =~ /^1\.8/
  gem "system_timer"
end
