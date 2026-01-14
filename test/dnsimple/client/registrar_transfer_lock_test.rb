# frozen_string_literal: true

require "test_helper"

class RegistrarTransferLockTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar
    @account_id = 1010
    @domain_id = "example.com"
  end


  def test_get_domain_transfer_lock_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/#{@domain_id}/transfer_lock})
        .to_return(read_http_fixture("getDomainTransferLock/success.http"))

    @subject.get_domain_transfer_lock(@account_id, @domain_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{@domain_id}/transfer_lock",
                     headers: { "Accept" => "application/json" })
  end

  def test_get_domain_transfer_lock_returns_the_transfer_lock_state
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/#{@domain_id}/transfer_lock})
        .to_return(read_http_fixture("getDomainTransferLock/success.http"))

    response = @subject.get_domain_transfer_lock(@account_id, @domain_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::TransferLock, result)
    assert(result.enabled)
  end

  def test_get_domain_transfer_lock_when_domain_does_not_exist_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.get_domain_transfer_lock(@account_id, @domain_id)
    end
  end


  def test_enable_domain_transfer_lock_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/#{@domain_id}/transfer_lock})
        .to_return(read_http_fixture("enableDomainTransferLock/success.http"))

    @subject.enable_domain_transfer_lock(@account_id, @domain_id)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{@domain_id}/transfer_lock",
                     headers: { "Accept" => "application/json" })
  end

  def test_enable_domain_transfer_lock_returns_the_transfer_lock_state
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/#{@domain_id}/transfer_lock})
        .to_return(read_http_fixture("enableDomainTransferLock/success.http"))

    response = @subject.enable_domain_transfer_lock(@account_id, @domain_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::TransferLock, result)
    assert(result.enabled)
  end

  def test_enable_domain_transfer_lock_when_domain_does_not_exist_raises_not_found_error
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.enable_domain_transfer_lock(@account_id, @domain_id)
    end
  end


  def test_disable_domain_transfer_lock_builds_correct_request
    stub_request(:delete, %r{/v2/#{@account_id}/registrar/domains/#{@domain_id}})
        .to_return(read_http_fixture("disableDomainTransferLock/success.http"))

    @subject.disable_domain_transfer_lock(@account_id, @domain_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{@domain_id}/transfer_lock",
                     headers: { "Accept" => "application/json" })
  end

  def test_disable_domain_transfer_lock_returns_the_transfer_lock_state
    stub_request(:delete, %r{/v2/#{@account_id}/registrar/domains/#{@domain_id}})
        .to_return(read_http_fixture("disableDomainTransferLock/success.http"))

    response = @subject.disable_domain_transfer_lock(@account_id, @domain_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::TransferLock, result)
    refute(result.enabled)
  end

  def test_disable_domain_transfer_lock_when_domain_does_not_exist_raises_not_found_error
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.disable_domain_transfer_lock(@account_id, @domain_id)
    end
  end
end
