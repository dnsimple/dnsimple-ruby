require 'vcr'
require 'lib/dnsimple'

VCR.config do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.stub_with :fakeweb
end

RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
end

config = YAML.load(File.new(File.expand_path('~/.dnsimple.test')))

DNSimple::Client.base_uri = config['site'] || "https://test.dnsimple.com/" 
DNSimple::Client.username = config['username']
DNSimple::Client.password = config['password'] 
