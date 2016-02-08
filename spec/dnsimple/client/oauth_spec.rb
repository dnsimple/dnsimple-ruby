require 'spec_helper'

describe Dnsimple::Client, ".oauth" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").oauth }


  describe "#authorize_url" do
    it "builds the correct url" do
      url = subject.authorize_url("great-app")
      expect(url).to eq("https://dnsimple.test/oauth/authorize?client_id=great-app&response_type=code")
    end

    it "exposes the options in the query string" do
      url = subject.authorize_url("great-app", secret: "1", redirect_uri: "http://example.com")
      expect(url).to eq("https://dnsimple.test/oauth/authorize?client_id=great-app&secret=1&redirect_uri=http://example.com&response_type=code")
    end
  end

end
