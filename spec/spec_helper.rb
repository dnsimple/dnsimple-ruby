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

Dir[File.join(SPEC_ROOT, "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.warnings = true
end
