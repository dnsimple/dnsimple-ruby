require 'spec_helper'

describe Dnsimple::Client, ".registrar" do

  subject { described_class.new(api_endpoint: "https://api.dnsimple.test", access_token: "a1b2c3").registrar }


  describe "#register" do
    let(:account_id) { 1010 }

    before do
      stub_request(:post, %r[/v2/#{account_id}/registrar/.+/registration$])
          .to_return(read_http_fixture("register/success.http"))
    end

    let(:attributes) { { registrant_id: "10" } }

    it "builds the correct request" do
      subject.register(account_id, domain_name = "example.com", attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/#{domain_name}/registration")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      response = subject.register(account_id, "example.com", attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to be_a(Fixnum)
    end
  end

end
