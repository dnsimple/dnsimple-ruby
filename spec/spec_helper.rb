require 'rspec'

if ENV['COVERALL']
  require 'coveralls'
  Coveralls.wear!
end

$:.unshift(File.dirname(__FILE__) + '/lib')
require 'dnsimple'

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.expand_path("../", __FILE__)
end

CONFIG = { 'username' => 'username', 'password' => 'password', 'base_uri' => 'https://api.sandbox.dnsimple.com/', 'host' => 'api.sandbox.dnsimple.com' }
DNSimple::Client.base_uri = CONFIG['base_uri']
DNSimple::Client.username = CONFIG['username']
DNSimple::Client.password = CONFIG['password']


RSpec.configure do |c|
  c.mock_framework = :mocha

  # Silent the puts call in the commands
  # c.before do
  #   @_stdout = $stdout
  #   $stdout = StringIO.new
  # end
  # c.after do
  #   $stdout = @_stdout
  # end
end

Dir[File.join(SPEC_ROOT, "support/**/*.rb")].each { |f| require f }
