require 'spec_helper'

describe Dnsimple::Client, ".registrar" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar }

  describe "#domain_delegation" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/.+/delegation$}).
          to_return(read_http_fixture("getDomainDelegation/success.http"))
    end

    it "builds the correct request" do
      subject.domain_delegation(account_id, domain_name = "example.com")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/delegation").
          with(headers: { "Accept" => "application/json" })
    end

    it "returns the name servers of the domain" do
      response = subject.domain_delegation(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      expect(response.data).to match_array(%w{ns1.dnsimple.com ns2.dnsimple.com ns3.dnsimple.com ns4.dnsimple.com})
    end
  end

end
