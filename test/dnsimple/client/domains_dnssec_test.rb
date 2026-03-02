# frozen_string_literal: true

require "test_helper"

class DomainsDnssecTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains
    @account_id = 1010
    @domain_id = "example.com"
  end

  test "enable dnssec builds correct request" do
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/dnssec})
        .to_return(read_http_fixture("enableDnssec/success.http"))

    @subject.enable_dnssec(@account_id, @domain_id)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/dnssec",
                     headers: { "Accept" => "application/json" })
  end

  test "enable dnssec returns the dnssec status" do
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/dnssec})
        .to_return(read_http_fixture("enableDnssec/success.http"))

    response = @subject.enable_dnssec(@account_id, @domain_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Dnssec, result)
    assert(result.enabled)
  end

  test "enable dnssec when domain not found raises not found error" do
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.enable_dnssec(@account_id, @domain_id)
    end
  end

  test "disable dnssec builds correct request" do
    stub_request(:delete, %r{/v2/#{@account_id}/domains/#{@domain_id}/dnssec})
        .to_return(read_http_fixture("disableDnssec/success.http"))

    @subject.disable_dnssec(@account_id, @domain_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/dnssec",
                     headers: { "Accept" => "application/json" })
  end

  test "disable dnssec returns nothing" do
    stub_request(:delete, %r{/v2/#{@account_id}/domains/#{@domain_id}/dnssec})
        .to_return(read_http_fixture("disableDnssec/success.http"))

    response = @subject.disable_dnssec(@account_id, @domain_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end

  test "disable dnssec when domain not found raises not found error" do
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.disable_dnssec(@account_id, @domain_id)
    end
  end

  test "get dnssec builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/dnssec})
        .to_return(read_http_fixture("getDnssec/success.http"))

    @subject.get_dnssec(@account_id, @domain_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/dnssec",
                     headers: { "Accept" => "application/json" })
  end

  test "get dnssec returns the dnssec status" do
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/dnssec})
        .to_return(read_http_fixture("getDnssec/success.http"))

    response = @subject.get_dnssec(@account_id, @domain_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Dnssec, result)
    assert(result.enabled)
  end

  test "get dnssec when domain not found raises not found error" do
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.get_dnssec(@account_id, @domain_id)
    end
  end
end
