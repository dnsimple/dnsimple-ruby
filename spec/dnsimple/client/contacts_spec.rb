require 'spec_helper'

describe Dnsimple::Client, ".contacts" do

  subject { described_class.new(api_endpoint: "https://api.dnsimple.test", access_token: "a1b2c3").contacts }


end
