# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{keen}
  s.version = "0.1.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["dorkitude"]
  s.date = %q{2012-06-20}
  s.description = %q{See the github repo or examples.rb for usage information.}
  s.email = %q{kyle@keen.io}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".rvmrc",
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION.yml",
    "conf/cacert.pem",
    "examples.rb",
    "features/add_event.feature",
    "features/redis_queue.feature",
    "features/step_definitions/keen_steps.rb",
    "features/support/before_and_after.rb",
    "features/support/env.rb",
    "keen.gemspec",
    "keen.gemspec.old",
    "lib/keen.rb",
    "lib/keen/async.rb",
    "lib/keen/async/job.rb",
    "lib/keen/async/storage/base_storage_handler.rb",
    "lib/keen/async/storage/flat_file_handler.rb",
    "lib/keen/async/storage/redis_handler.rb",
    "lib/keen/async/worker.rb",
    "lib/keen/client.rb",
    "lib/keen/event.rb",
    "lib/keen/keys.rb",
    "lib/keen/utils.rb",
    "lib/keen/version.rb",
    "send.rb"
  ]
  s.homepage = %q{http://github.com/dorkitude/keen}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.2}
  s.summary = %q{A library for batching and sending arbitrary events to the Keen API at http://keen.io}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 1.6.5"])
      s.add_runtime_dependency(%q<redis>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, [">= 1.1.4"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_development_dependency(%q<rspec>, [">= 2.9.0"])
      s.add_development_dependency(%q<cucumber>, [">= 1.2.1"])
    else
      s.add_dependency(%q<json>, [">= 1.6.5"])
      s.add_dependency(%q<redis>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, [">= 1.1.4"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
      s.add_dependency(%q<rspec>, [">= 2.9.0"])
      s.add_dependency(%q<cucumber>, [">= 1.2.1"])
    end
  else
    s.add_dependency(%q<json>, [">= 1.6.5"])
    s.add_dependency(%q<redis>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, [">= 1.1.4"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.3"])
    s.add_dependency(%q<rspec>, [">= 2.9.0"])
    s.add_dependency(%q<cucumber>, [">= 1.2.1"])
  end
end

