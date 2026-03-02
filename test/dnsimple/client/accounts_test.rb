# frozen_string_literal: true

require "test_helper"

class AccountsTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").accounts
  end

  test "builds the correct request" do
    stub_request(:get, %r{/v2/accounts$})
        .to_return(read_http_fixture("listAccounts/success-user.http"))

    @subject.accounts

    assert_requested(:get, "https://api.dnsimple.test/v2/accounts",
                     headers: { "Accept" => "application/json" })
  end

  test "returns the accounts" do
    stub_request(:get, %r{/v2/accounts$})
        .to_return(read_http_fixture("listAccounts/success-user.http"))

    response = @subject.accounts

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Account, result.first)
    assert_kind_of(Dnsimple::Struct::Account, result.last)
  end
end
