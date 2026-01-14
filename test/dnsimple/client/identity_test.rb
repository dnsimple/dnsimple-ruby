# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".identity" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").identity }


  describe "#whoami" do
    before do
      stub_request(:get, %r{/v2/whoami$})
          .to_return(read_http_fixture("whoami/success.http"))
    end

    it "builds the correct request" do
      subject.whoami

      assert_requested(:get, "https://api.dnsimple.test/v2/whoami",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the whoami" do
      response = subject.whoami
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Whoami)
    end

    describe "when authenticated as account" do
      before do
        stub_request(:get, %r{/v2/whoami$})
            .to_return(read_http_fixture("whoami/success-account.http"))
      end

      it "sets the account" do
        result = subject.whoami.data
        _(result.account).must_be_kind_of(Dnsimple::Struct::Account)
        _(result.user).must_be_nil
      end
    end

    describe "when authenticated as user" do
      before do
        stub_request(:get, %r{/v2/whoami$})
            .to_return(read_http_fixture("whoami/success-user.http"))
      end

      it "sets the user" do
        result = subject.whoami.data
        _(result.account).must_be_nil
        _(result.user).must_be_kind_of(Dnsimple::Struct::User)
      end
    end
  end

end
