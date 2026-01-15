# frozen_string_literal: true

require "test_helper"

class RegistrarDelegationTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar
    @account_id = 1010
  end


  test "domain delegation builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/.+/delegation$})
        .to_return(read_http_fixture("getDomainDelegation/success.http"))

    @subject.domain_delegation(@account_id, domain_name = "example.com")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/delegation",
                     headers: { "Accept" => "application/json" })
  end

  test "domain delegation returns the name servers of the domain" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/.+/delegation$})
        .to_return(read_http_fixture("getDomainDelegation/success.http"))

    response = @subject.domain_delegation(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)

    assert_equal(%w[ns1.dnsimple.com ns2.dnsimple.com ns3.dnsimple.com ns4.dnsimple.com].sort, response.data.sort)
  end


  test "change domain delegation builds correct request" do
    stub_request(:put, %r{/v2/#{@account_id}/registrar/domains/.+/delegation$})
        .to_return(read_http_fixture("changeDomainDelegation/success.http"))

    attributes = %w[ns1.dnsimple.com ns2.dnsimple.com ns3.dnsimple.com ns4.dnsimple.com]
    @subject.change_domain_delegation(@account_id, domain_name = "example.com", attributes)

    assert_requested(:put, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/delegation",
                     body: JSON.dump(attributes),
                     headers: { "Accept" => "application/json" })
  end

  test "change domain delegation returns the name servers of the domain" do
    stub_request(:put, %r{/v2/#{@account_id}/registrar/domains/.+/delegation$})
        .to_return(read_http_fixture("changeDomainDelegation/success.http"))

    attributes = %w[ns1.dnsimple.com ns2.dnsimple.com ns3.dnsimple.com ns4.dnsimple.com]
    response = @subject.change_domain_delegation(@account_id, "example.com", attributes)

    assert_kind_of(Dnsimple::Response, response)

    assert_equal(%w[ns1.dnsimple.com ns2.dnsimple.com ns3.dnsimple.com ns4.dnsimple.com].sort, response.data.sort)
  end


  test "change domain delegation to vanity builds correct request" do
    stub_request(:put, %r{/v2/#{@account_id}/registrar/domains/.+/delegation/vanity$})
        .to_return(read_http_fixture("changeDomainDelegationToVanity/success.http"))

    attributes = %w[ns1.example.com ns2.example.com]
    @subject.change_domain_delegation_to_vanity(@account_id, domain_name = "example.com", attributes)

    assert_requested(:put, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/delegation/vanity",
                     body: JSON.dump(attributes),
                     headers: { "Accept" => "application/json" })
  end

  test "change domain delegation to vanity returns vanity name servers of the domain" do
    stub_request(:put, %r{/v2/#{@account_id}/registrar/domains/.+/delegation/vanity$})
        .to_return(read_http_fixture("changeDomainDelegationToVanity/success.http"))

    attributes = %w[ns1.example.com ns2.example.com]
    response = @subject.change_domain_delegation_to_vanity(@account_id, "example.com", attributes)

    assert_kind_of(Dnsimple::Response, response)

    vanity_name_server = response.data.first

    assert_kind_of(Dnsimple::Struct::VanityNameServer, vanity_name_server)
    assert_equal("ns1.example.com", vanity_name_server.name)
  end


  test "change domain delegation from vanity builds correct request" do
    stub_request(:delete, %r{/v2/#{@account_id}/registrar/domains/.+/delegation/vanity$})
        .to_return(read_http_fixture("changeDomainDelegationFromVanity/success.http"))

    @subject.change_domain_delegation_from_vanity(@account_id, domain_name = "example.com")

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/delegation/vanity",
                     headers: { "Accept" => "application/json" })
  end

  test "change domain delegation from vanity returns empty response" do
    stub_request(:delete, %r{/v2/#{@account_id}/registrar/domains/.+/delegation/vanity$})
        .to_return(read_http_fixture("changeDomainDelegationFromVanity/success.http"))

    response = @subject.change_domain_delegation_from_vanity(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end
end
