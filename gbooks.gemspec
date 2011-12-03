# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gbooks/version"

Gem::Specification.new do |s|
  s.name        = "gbooks"
  s.version     = Gbooks::VERSION
  s.authors     = ["Zean Tsoi"]
  s.email       = ["zean.tsoi@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Wrapper for Google Books via the Google API}
  s.description = %q{Replaces the deprecated Google Books API. Provides support for distributed server networks such as Heroku.}

  s.rubyforge_project = "gbooks"

  s.add_dependency('httparty')

  #s.files         = `git ls-files`.split("\n")
  s.files         = Dir["{lib}/**/*", "gbooks.gemspec", "Gemfile", "Rakefile"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
