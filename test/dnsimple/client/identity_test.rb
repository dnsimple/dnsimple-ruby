# frozen_string_literal: true

require "test_helper"

class IdentityTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").identity
  end

  def test_whoami_builds_correct_request
    stub_request(:get, %r{/v2/whoami$})
        .to_return(read_http_fixture("whoami/success.http"))

    @subject.whoami

    assert_requested(:get, "https://api.dnsimple.test/v2/whoami",
                     headers: { "Accept" => "application/json" })
  end

  def test_whoami_returns_the_whoami
    stub_request(:get, %r{/v2/whoami$})
        .to_return(read_http_fixture("whoami/success.http"))

    response = @subject.whoami

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Whoami, result)
  end

  def test_whoami_when_authenticated_as_account_sets_the_account
    stub_request(:get, %r{/v2/whoami$})
        .to_return(read_http_fixture("whoami/success-account.http"))

    result = @subject.whoami.data

    assert_kind_of(Dnsimple::Struct::Account, result.account)
    assert_nil(result.user)
  end

  def test_whoami_when_authenticated_as_user_sets_the_user
    stub_request(:get, %r{/v2/whoami$})
        .to_return(read_http_fixture("whoami/success-user.http"))

    result = @subject.whoami.data

    assert_nil(result.account)
    assert_kind_of(Dnsimple::Struct::User, result.user)
  end
end
