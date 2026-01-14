# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".oauth" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test").oauth }


  describe "#exchange_authorization_for_token" do
    let(:client_id) { "super-client" }
    let(:client_secret) { "super-secret" }
    let(:code) { "super-code" }
    let(:state) { "super-state" }

    before do
      stub_request(:post, %r{/v2/oauth/access_token$})
          .to_return(read_http_fixture("oauthAccessToken/success.http"))
    end

    it "builds the correct request" do
      subject.exchange_authorization_for_token(code, client_id, client_secret, state:)

      assert_requested(:post, "https://api.dnsimple.test/v2/oauth/access_token",
                       body: { client_id:, client_secret:, code:, state:, grant_type: "authorization_code" },
                       headers: { "Accept" => "application/json" })
    end

    it "returns oauth token" do
      result = subject.exchange_authorization_for_token(code, client_id, client_secret, state:)

      _(result).must_be_kind_of(Dnsimple::Struct::OauthToken)
      _(result.access_token).must_equal("zKQ7OLqF5N1gylcJweA9WodA000BUNJD")
      _(result.token_type).must_equal("Bearer")
      _(result.account_id).must_equal(1)
    end

    describe "when state and redirect_uri are provided" do
      let(:redirect_uri) { "super-redirect-uri" }

      it "builds the correct request" do
        subject.exchange_authorization_for_token(code, client_id, client_secret, state:, redirect_uri:)

        assert_requested(:post, "https://api.dnsimple.test/v2/oauth/access_token",
                         body: { client_id:, client_secret:, code:, state:, redirect_uri:, grant_type: "authorization_code" },
                         headers: { "Accept" => "application/json" })
      end
    end

    describe "when the request fails with 400" do
      before do
        stub_request(:post, %r{/v2/oauth/access_token$})
            .to_return(read_http_fixture("oauthAccessToken/error-invalid-request.http"))
      end

      it "raises OAuthInvalidRequestError" do
        error = _ {
          subject.exchange_authorization_for_token(code, client_id, client_secret, state:)
        }.must_raise(Dnsimple::OAuthInvalidRequestError)
        _(error.error).must_equal("invalid_request")
        _(error.error_description).must_equal("Invalid \"state\": value doesn't match the \"state\" in the authorization request")
      end
    end
  end

  describe "#authorize_url" do
    it "builds the correct url" do
      url = subject.authorize_url("great-app")
      _(url).must_equal("https://dnsimple.test/oauth/authorize?client_id=great-app&response_type=code")
    end

    it "exposes the options in the query string" do
      url = subject.authorize_url("great-app", secret: "1", redirect_uri: "http://example.com")
      _(url).must_equal("https://dnsimple.test/oauth/authorize?client_id=great-app&secret=1&redirect_uri=http://example.com&response_type=code")
    end
  end

end
