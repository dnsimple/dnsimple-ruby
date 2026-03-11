# frozen_string_literal: true

require "test_helper"

class OauthTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test").oauth
    @client_id = "super-client"
    @client_secret = "super-secret"
    @code = "super-code"
    @state = "super-state"
  end

  test "exchange authorization for token builds correct request" do
    stub_request(:post, %r{/v2/oauth/access_token$})
        .to_return(read_http_fixture("oauthAccessToken/success.http"))

    @subject.exchange_authorization_for_token(@code, @client_id, @client_secret, state: @state)

    assert_requested(:post, "https://api.dnsimple.test/v2/oauth/access_token",
                     body: { client_id: @client_id, client_secret: @client_secret, code: @code, state: @state, grant_type: "authorization_code" },
                     headers: { "Accept" => "application/json" })
  end

  test "exchange authorization for token returns oauth token" do
    stub_request(:post, %r{/v2/oauth/access_token$})
        .to_return(read_http_fixture("oauthAccessToken/success.http"))

    result = @subject.exchange_authorization_for_token(@code, @client_id, @client_secret, state: @state)

    assert_kind_of(Dnsimple::Struct::OauthToken, result)
    assert_equal("zKQ7OLqF5N1gylcJweA9WodA000BUNJD", result.access_token)
    assert_equal("Bearer", result.token_type)
    assert_equal(1, result.account_id)
  end

  test "exchange authorization for token with state and redirect uri builds correct request" do
    stub_request(:post, %r{/v2/oauth/access_token$})
        .to_return(read_http_fixture("oauthAccessToken/success.http"))

    redirect_uri = "super-redirect-uri"
    @subject.exchange_authorization_for_token(@code, @client_id, @client_secret, state: @state, redirect_uri:)

    assert_requested(:post, "https://api.dnsimple.test/v2/oauth/access_token",
                     body: { client_id: @client_id, client_secret: @client_secret, code: @code, state: @state, redirect_uri:, grant_type: "authorization_code" },
                     headers: { "Accept" => "application/json" })
  end

  test "exchange authorization for token when request fails with 400 raises oauth invalid request error" do
    stub_request(:post, %r{/v2/oauth/access_token$})
        .to_return(read_http_fixture("oauthAccessToken/error-invalid-request.http"))

    error = assert_raises(Dnsimple::OAuthInvalidRequestError) do
      @subject.exchange_authorization_for_token(@code, @client_id, @client_secret, state: @state)
    end
    assert_equal("invalid_request", error.error)
    assert_equal("Invalid \"state\": value doesn't match the \"state\" in the authorization request", error.error_description)
  end

  test "authorize url builds correct url" do
    url = @subject.authorize_url("great-app")

    assert_equal("https://dnsimple.test/oauth/authorize?client_id=great-app&response_type=code", url)
  end

  test "authorize url exposes options in query string" do
    url = @subject.authorize_url("great-app", secret: "1", redirect_uri: "http://example.com")

    assert_equal("https://dnsimple.test/oauth/authorize?client_id=great-app&secret=1&redirect_uri=http://example.com&response_type=code", url)
  end
end
