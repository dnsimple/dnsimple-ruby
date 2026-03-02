# frozen_string_literal: true

require "test_helper"

class DomainsResearchTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains
    @account_id = 1010
  end

  test "domain_research_status builds the correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/domains/research/status})
        .with(query: { domain: "taken.com" })
        .to_return(read_http_fixture("getDomainsResearchStatus/success-unavailable.http"))

    @subject.domain_research_status(@account_id, domain_name = "taken.com")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/research/status",
                     query: { domain: domain_name },
                     headers: { "Accept" => "application/json" })
  end

  test "domain_research_status returns the domain research status" do
    stub_request(:get, %r{/v2/#{@account_id}/domains/research/status})
        .with(query: { domain: "taken.com" })
        .to_return(read_http_fixture("getDomainsResearchStatus/success-unavailable.http"))

    response = @subject.domain_research_status(@account_id, "taken.com")

    assert_instance_of Dnsimple::Response, response

    result = response.data

    assert_instance_of Dnsimple::Struct::DomainResearchStatus, result
    assert_equal "25dd77cb-2f71-48b9-b6be-1dacd2881418", result.request_id
    assert_equal "taken.com", result.domain
    assert_equal "unavailable", result.availability
    assert_empty result.errors
  end
end
