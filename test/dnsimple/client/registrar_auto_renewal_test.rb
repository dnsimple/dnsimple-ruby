# frozen_string_literal: true

require "test_helper"

class RegistrarAutoRenewalTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar
    @account_id = 1010
    @domain_id = "example.com"
  end


  test "enable auto renewal builds correct request" do
    stub_request(:put, %r{/v2/#{@account_id}/registrar/domains/#{@domain_id}})
        .to_return(read_http_fixture("enableDomainAutoRenewal/success.http"))

    @subject.enable_auto_renewal(@account_id, @domain_id)

    assert_requested(:put, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{@domain_id}/auto_renewal",
                     headers: { "Accept" => "application/json" })
  end

  test "enable auto renewal returns nothing" do
    stub_request(:put, %r{/v2/#{@account_id}/registrar/domains/#{@domain_id}})
        .to_return(read_http_fixture("enableDomainAutoRenewal/success.http"))

    response = @subject.enable_auto_renewal(@account_id, @domain_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end

  test "enable auto renewal when domain does not exist raises not found error" do
    stub_request(:put, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.enable_auto_renewal(@account_id, @domain_id)
    end
  end


  test "disable auto renewal builds correct request" do
    stub_request(:delete, %r{/v2/#{@account_id}/registrar/domains/#{@domain_id}})
        .to_return(read_http_fixture("disableDomainAutoRenewal/success.http"))

    @subject.disable_auto_renewal(@account_id, @domain_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{@domain_id}/auto_renewal",
                     headers: { "Accept" => "application/json" })
  end

  test "disable auto renewal returns nothing" do
    stub_request(:delete, %r{/v2/#{@account_id}/registrar/domains/#{@domain_id}})
        .to_return(read_http_fixture("disableDomainAutoRenewal/success.http"))

    response = @subject.disable_auto_renewal(@account_id, @domain_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end

  test "disable auto renewal when domain does not exist raises not found error" do
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.disable_auto_renewal(@account_id, @domain_id)
    end
  end
end
