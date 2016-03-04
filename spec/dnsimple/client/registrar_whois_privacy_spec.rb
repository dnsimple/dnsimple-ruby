require 'spec_helper'

describe Dnsimple::Client, ".registrar" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar }


  describe "#whois_privacy" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r[/v2/#{account_id}/registrar/domains/.+/whois_privacy$])
          .to_return(read_http_fixture("getWhoisPrivacy/success.http"))
    end

    it "builds the correct request" do
      subject.whois_privacy(account_id, domain_name = "example.com")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/whois_privacy")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the whois privacy" do
      response = subject.whois_privacy(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::WhoisPrivacy)
      expect(result.enabled).to be_truthy
      expect(result.domain_id).to be_kind_of(Fixnum)
      expect(result.expires_on).to be_kind_of(String)
    end
  end

end
