require 'rubygems'
require 'bundler/setup'
require 'cgi'
require 'vcr'

$:.unshift(File.dirname(__FILE__) + '/lib')
require 'dnsimple'

config = YAML.load_file(File.expand_path(ENV['DNSIMPLE_TEST_CONFIG'] || '~/.dnsimple.test'))

DNSimple::Client.base_uri   = config['site']      if config['site']     # Example: https://test.dnsimple.com/
DNSimple::Client.host       = config['host']      if config['host']     # Example: test.dnsimple.com
DNSimple::Client.username   = config['username']                        # Example: testusername@example.com
DNSimple::Client.password   = config['password']                        # Example: testpassword
DNSimple::Client.api_token  = config['api_token']                       # Example: 1234567890

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :fakeweb
  c.filter_sensitive_data("<USERNAME>") { CGI::escape(DNSimple::Client.username) }
  c.filter_sensitive_data("<PASSWORD>") { CGI::escape(DNSimple::Client.password) }
end

RSpec.configure do |c|
  c.mock_framework = :mocha
  c.extend VCR::RSpec::Macros

  # Silent the puts call in the commands
  c.before do
    @_stdout = $stdout
    $stdout = StringIO.new
  end
  c.after do
    $stdout = @_stdout
  end
end

