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

RSpec.configure do |c|
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
