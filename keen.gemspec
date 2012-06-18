# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "keen/version"

Gem::Specification.new do |s|
  s.name        = "keen"
  s.version     = Keen::VERSION
  s.authors     = ["Kyle Wild"]
  s.email       = ["kyle@keen.io"]
  s.homepage    = "https://github.com/keenlabs/KeenClient-Ruby"
  s.summary     = "A library for sending events to the keen.io API."
  s.description = "See the github repo or examples.rb for usage information."

  s.rubyforge_project = "keen"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extensions = ["ext/mkrf_conf.rb"]
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  
  s.add_dependency("json", ">= 1.6.5")
  s.add_development_dependency("rspec", ">= 2.9.0")
  s.add_development_dependency("cucumber", ">= 1.2.1")

  # This is no longer necessary, since we support several storage modes now:
  # s.add_dependency("redis", ">= 2.2.2")

end
