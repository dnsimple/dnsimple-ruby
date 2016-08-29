require 'spec_helper'

describe Dnsimple::Client, ".accounts" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").accounts }


  describe "#accounts" do
    before do
      stub_request(:get, %r{/v2/accounts$}).
          to_return(read_http_fixture("listAccounts/success-user.http"))
    end

    it "builds the correct request" do
      subject.accounts

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/accounts").
          with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the accounts" do
      response = subject.accounts
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result.first).to be_a(Dnsimple::Struct::Account)
      expect(result.last).to be_a(Dnsimple::Struct::Account)
    end
  end

end
