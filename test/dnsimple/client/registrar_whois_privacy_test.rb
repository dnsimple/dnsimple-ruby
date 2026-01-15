# frozen_string_literal: true

require "test_helper"

class RegistrarWhoisPrivacyTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar
    @account_id = 1010
  end


  test "enable whois privacy when already purchased builds correct request" do
    stub_request(:put, %r{/v2/#{@account_id}/registrar/domains/.+/whois_privacy$})
        .to_return(read_http_fixture("enableWhoisPrivacy/success.http"))

    @subject.enable_whois_privacy(@account_id, domain_name = "example.com")

    assert_requested(:put, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/whois_privacy",
                     headers: { "Accept" => "application/json" })
  end

  test "enable whois privacy when already purchased returns the whois privacy" do
    stub_request(:put, %r{/v2/#{@account_id}/registrar/domains/.+/whois_privacy$})
        .to_return(read_http_fixture("enableWhoisPrivacy/success.http"))

    response = @subject.enable_whois_privacy(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)
    assert_equal(200, response.http_response.code)

    result = response.data

    assert_kind_of(Dnsimple::Struct::WhoisPrivacy, result)
    assert_kind_of(Integer, result.domain_id)
    assert(result.enabled)
    assert_kind_of(String, result.expires_on)
  end

  test "enable whois privacy when newly purchased builds correct request" do
    stub_request(:put, %r{/v2/#{@account_id}/registrar/domains/.+/whois_privacy$})
        .to_return(read_http_fixture("enableWhoisPrivacy/created.http"))

    @subject.enable_whois_privacy(@account_id, domain_name = "example.com")

    assert_requested(:put, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/whois_privacy",
                     headers: { "Accept" => "application/json" })
  end

  test "enable whois privacy when newly purchased returns the whois privacy" do
    stub_request(:put, %r{/v2/#{@account_id}/registrar/domains/.+/whois_privacy$})
        .to_return(read_http_fixture("enableWhoisPrivacy/created.http"))

    response = @subject.enable_whois_privacy(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)
    assert_equal(201, response.http_response.code)

    result = response.data

    assert_kind_of(Dnsimple::Struct::WhoisPrivacy, result)
    assert_kind_of(Integer, result.domain_id)
    assert_nil(result.enabled)
    assert_nil(result.expires_on)
  end


  test "disable whois privacy builds correct request" do
    stub_request(:delete, %r{/v2/#{@account_id}/registrar/domains/.+/whois_privacy$})
        .to_return(read_http_fixture("disableWhoisPrivacy/success.http"))

    @subject.disable_whois_privacy(@account_id, domain_name = "example.com")

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/whois_privacy",
                     headers: { "Accept" => "application/json" })
  end

  test "disable whois privacy returns the whois privacy" do
    stub_request(:delete, %r{/v2/#{@account_id}/registrar/domains/.+/whois_privacy$})
        .to_return(read_http_fixture("disableWhoisPrivacy/success.http"))

    response = @subject.disable_whois_privacy(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::WhoisPrivacy, result)
    assert_kind_of(Integer, result.domain_id)
    refute(result.enabled)
    assert_kind_of(String, result.expires_on)
  end
end
