# frozen_string_literal: true

require "minitest/autorun"
require "minitest/mock"
require "webmock/minitest"

if ENV["COVERALL"]
  require "coveralls"
  Coveralls.wear!
end

$:.unshift("#{File.dirname(__FILE__)}/lib")
require "dnsimple"

unless defined?(TEST_ROOT)
  TEST_ROOT = File.expand_path(__dir__)
end

WebMock.disable_net_connect!

module TestHelpers
  def http_fixture(*names)
    File.join(TEST_ROOT, "fixtures.http", *names)
  end

  def read_http_fixture(*names)
    File.read(http_fixture(*names))
  end
end

class Minitest::Spec # rubocop:disable Style/ClassAndModuleChildren
  include TestHelpers
end
