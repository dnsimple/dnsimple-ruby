# frozen_string_literal: true

require "spec_helper"

describe Dnsimple::Client, ".identity" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").identity }


  describe "#whoami" do
    before do
      stub_request(:get, %r{/v2/whoami$})
          .to_return(read_http_fixture("whoami/success.http"))
    end

    it "builds the correct request" do
      subject.whoami

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/whoami")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the whoami" do
      response = subject.whoami
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Whoami)
    end

    context "when authenticated as account" do
      before do
        stub_request(:get, %r{/v2/whoami$})
            .to_return(read_http_fixture("whoami/success-account.http"))
      end

      it "sets the account" do
        result = subject.whoami.data
        expect(result.account).to be_a(Dnsimple::Struct::Account)
        expect(result.user).to be_nil
      end
    end

    context "when authenticated as user" do
      before do
        stub_request(:get, %r{/v2/whoami$})
            .to_return(read_http_fixture("whoami/success-user.http"))
      end

      it "sets the user" do
        result = subject.whoami.data
        expect(result.account).to be_nil
        expect(result.user).to be_a(Dnsimple::Struct::User)
      end
    end
  end

end
