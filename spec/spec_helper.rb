require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'vcr'
require 'webmock/rspec'

require 'googlebooks'

RSpec.configure do |config|
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
end
