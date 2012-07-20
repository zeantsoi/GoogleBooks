# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "googlebooks"
  s.version     = GoogleBooks::VERSION
  s.authors     = ["Zean Tsoi"]
  s.email       = ["zean.tsoi@gmail.com"]
  s.homepage    = "https://github.com/zeantsoi/googlebooks"
  s.summary     = %q{GoogleBooks is a lightweight Ruby wrapper that queries the Google API to search for publications in the Google Books repository.}
 
  s.description = %q{GoogleBooks is a lightweight Ruby wrapper that queries the Google API to search for publications in the Google Books repository. It is inspired by the google-book gem which relies on the deprecated Google GData Books API, but is updated to hook into the current Google API.}

  s.rubyforge_project = "googlebooks"

  s.add_dependency('httparty')
  s.add_development_dependency('rspec')
  s.add_development_dependency('webmock')
  
  s.files         = `git ls-files`.split("\n")
  #s.files         = Dir["{lib}/**/*", "googlebooks.gemspec", "Gemfile", "Rakefile"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
