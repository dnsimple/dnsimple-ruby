require 'rubygems'
require 'bundler/setup'
require 'cgi'
require 'vcr'

$:.unshift(File.dirname(__FILE__) + '/lib')
require 'dnsimple'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :fakeweb
  c.filter_sensitive_data("<USERNAME>") { CGI::escape(DNSimple::Client.username) }
  c.filter_sensitive_data("<PASSWORD>") { CGI::escape(DNSimple::Client.password) }
end

RSpec.configure do |c|
  c.mock_framework = :mocha
  c.extend VCR::RSpec::Macros
end

config = YAML.load(File.new(File.expand_path('~/.dnsimple.local')))

DNSimple::Client.base_uri = config['site']      # Example: https://test.dnsimple.com/
DNSimple::Client.username = config['username']  # Example: testusername
DNSimple::Client.password = config['password']  # Example: testpassword
