require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:suite) do
    WebMock.disable_net_connect!
  end

  config.after(:suite) do
    WebMock.allow_net_connect!
  end
end
