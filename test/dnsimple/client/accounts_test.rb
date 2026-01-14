# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".accounts" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").accounts }


  describe "#accounts" do
    before do
      stub_request(:get, %r{/v2/accounts$})
          .to_return(read_http_fixture("listAccounts/success-user.http"))
    end

    it "builds the correct request" do
      subject.accounts

      assert_requested(:get, "https://api.dnsimple.test/v2/accounts",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the accounts" do
      response = subject.accounts
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result.first).must_be_kind_of(Dnsimple::Struct::Account)
      _(result.last).must_be_kind_of(Dnsimple::Struct::Account)
    end
  end

end
