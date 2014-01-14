require 'rubygems'
require 'bundler/setup'
require 'cgi'
require 'vcr'

$:.unshift(File.dirname(__FILE__) + '/lib')
require 'dnsimple'

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.expand_path("../", __FILE__)
end


CONFIG = YAML.load_file(File.expand_path(ENV['DNSIMPLE_TEST_CONFIG'] || '~/.dnsimple.test'))

DNSimple::Client.base_uri   = CONFIG['site']      if CONFIG['site']     # Example: https://test.dnsimple.com/
DNSimple::Client.base_uri   = CONFIG['base_uri']  if CONFIG['base_uri'] # Example: https://test.dnsimple.com/
DNSimple::Client.username   = CONFIG['username']                        # Example: testusername@example.com
DNSimple::Client.password   = CONFIG['password']                        # Example: testpassword
DNSimple::Client.api_token  = CONFIG['api_token']                       # Example: 1234567890

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

Dir[File.join(SPEC_ROOT, "support/**/*.rb")].each { |f| require f }
