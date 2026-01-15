# frozen_string_literal: true

require "test_helper"

class VanityNameServersTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").vanity_name_servers
    @account_id = 1010
  end

  test "enable vanity name servers builds correct request" do
    stub_request(:put, %r{/v2/#{@account_id}/vanity/.+$})
        .to_return(read_http_fixture("enableVanityNameServers/success.http"))

    domain_name = "example.com"
    @subject.enable_vanity_name_servers(@account_id, domain_name)

    assert_requested(:put, "https://api.dnsimple.test/v2/#{@account_id}/vanity/#{domain_name}",
                     headers: { "Accept" => "application/json" })
  end

  test "enable vanity name servers returns vanity name servers" do
    stub_request(:put, %r{/v2/#{@account_id}/vanity/.+$})
        .to_return(read_http_fixture("enableVanityNameServers/success.http"))

    response = @subject.enable_vanity_name_servers(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)

    vanity_name_servers = response.data.map { |ns| ns["name"] }

    assert_equal(%w[ns1.example.com ns2.example.com ns3.example.com ns4.example.com].sort, vanity_name_servers.sort)
  end

  test "disable vanity name servers builds correct request" do
    stub_request(:delete, %r{/v2/#{@account_id}/vanity/.+$})
        .to_return(read_http_fixture("disableVanityNameServers/success.http"))

    domain_name = "example.com"
    @subject.disable_vanity_name_servers(@account_id, domain_name)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/vanity/#{domain_name}",
                     headers: { "Accept" => "application/json" })
  end

  test "disable vanity name servers returns empty response" do
    stub_request(:delete, %r{/v2/#{@account_id}/vanity/.+$})
        .to_return(read_http_fixture("disableVanityNameServers/success.http"))

    response = @subject.disable_vanity_name_servers(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end
end
