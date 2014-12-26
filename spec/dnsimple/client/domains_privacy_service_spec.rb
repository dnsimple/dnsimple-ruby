require 'spec_helper'

describe Dnsimple::Client, ".domains / privacy" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").domains }



end
