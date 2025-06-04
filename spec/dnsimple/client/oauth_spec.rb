# frozen_string_literal: true

require "spec_helper"

describe Dnsimple::Client, ".oauth" do

  subject { described_class.new(base_url: "https://api.dnsimple.test").oauth }


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
      subject.exchange_authorization_for_token(code, client_id, client_secret, state: state)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/oauth/access_token")
          .with(body: { client_id: client_id, client_secret: client_secret, code: code, state: state, grant_type: "authorization_code" })
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns oauth token" do
      result = subject.exchange_authorization_for_token(code, client_id, client_secret, state: state)

      expect(result).to be_a(Dnsimple::Struct::OauthToken)
      expect(result.access_token).to eq("zKQ7OLqF5N1gylcJweA9WodA000BUNJD")
      expect(result.token_type).to eq("Bearer")
      expect(result.account_id).to eq(1)
    end

    context "when state and redirect_uri are provided" do
      let(:redirect_uri) { "super-redirect-uri" }

      it "builds the correct request" do
        subject.exchange_authorization_for_token(code, client_id, client_secret, state: state, redirect_uri: redirect_uri)

        expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/oauth/access_token")
            .with(body: { client_id: client_id, client_secret: client_secret, code: code, state: state, redirect_uri: redirect_uri, grant_type: "authorization_code" })
            .with(headers: { "Accept" => "application/json" })
      end
    end

    context "when the request fails with 400" do
      before do
        stub_request(:post, %r{/v2/oauth/access_token$})
            .to_return(read_http_fixture("oauthAccessToken/error-invalid-request.http"))
      end

      it "raises OAuthInvalidRequestError" do
        expect {
          subject.exchange_authorization_for_token(code, client_id, client_secret, state: state)
        }.to raise_error(Dnsimple::OAuthInvalidRequestError) do |e|
          error = "invalid_request"
          error_description = "Invalid \"state\": value doesn't match the \"state\" in the authorization request"
          expect(e.error).to eq(error)
          expect(e.error_description).to eq(error_description)
          expect(e.to_s).to eq("#{error}: #{error_description}")
        end
      end
    end
  end

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
