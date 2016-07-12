require 'spec_helper'

describe Dnsimple::Client, ".vanity_name_servers" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").vanity_name_servers }

  describe "#disable" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/vanity/.+$}).
          to_return(read_http_fixture("disableVanityNameServers/success.http"))
    end

    it "builds the correct request" do
      subject.disable(account_id, domain_name = "example.com")

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/vanity/#{domain_name}").
          with(headers: { "Accept" => "application/json" })
    end

    it "returns empty response" do
      response = subject.disable(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end
  end
end
