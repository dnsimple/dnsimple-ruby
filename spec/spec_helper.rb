# frozen_string_literal: true

require 'rspec'

$:.unshift("#{File.dirname(__FILE__)}/lib")
require 'dnsimple'

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.expand_path(__dir__)
end

Dir[File.join(SPEC_ROOT, "support/**/*.rb")].each { |f| require f }
