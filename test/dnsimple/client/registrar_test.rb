# frozen_string_literal: true

require "test_helper"

class RegistrarTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar
    @account_id = 1010
  end


  test "check domain builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/.+/check$})
        .to_return(read_http_fixture("checkDomain/success.http"))

    @subject.check_domain(@account_id, domain_name = "example.com")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/check",
                     headers: { "Accept" => "application/json" })
  end

  test "check domain returns the availability" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/.+/check$})
        .to_return(read_http_fixture("checkDomain/success.http"))

    response = @subject.check_domain(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DomainCheck, result)
    assert_equal("ruby.codes", result.domain)
    assert(result.available)
    assert(result.premium)
  end


  test "get domain prices builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/bingo.pizza/prices$})
        .to_return(read_http_fixture("getDomainPrices/success.http"))

    @subject.get_domain_prices(@account_id, "bingo.pizza")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/bingo.pizza/prices",
                     headers: { "Accept" => "application/json" })
  end

  test "get domain prices returns the prices" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/bingo.pizza/prices$})
        .to_return(read_http_fixture("getDomainPrices/success.http"))

    response = @subject.get_domain_prices(@account_id, "bingo.pizza")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DomainPrice, result)
    assert_equal("bingo.pizza", result.domain)
    assert(result.premium)
    assert_in_delta(20.0, result.registration_price)
    assert_in_delta(20.0, result.renewal_price)
    assert_in_delta(20.0, result.transfer_price)
  end

  test "get domain prices when tld is not supported raises error" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/bingo.pineapple/prices$})
        .to_return(read_http_fixture("getDomainPrices/failure.http"))

    assert_raises(Dnsimple::RequestError) do
      @subject.get_domain_prices(@account_id, "bingo.pineapple")
    end
  end


  test "register domain builds correct request" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/registrations$})
        .to_return(read_http_fixture("registerDomain/success.http"))

    attributes = { registrant_id: "10" }
    @subject.register_domain(@account_id, domain_name = "example.com", attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/registrations",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  test "register domain returns the domain" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/registrations$})
        .to_return(read_http_fixture("registerDomain/success.http"))

    attributes = { registrant_id: "10" }
    response = @subject.register_domain(@account_id, "example.com", attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DomainRegistration, result)
    assert_kind_of(Integer, result.id)
    assert_kind_of(Integer, result.domain_id)
  end

  test "register domain when attributes are incomplete raises argument error" do
    assert_raises(ArgumentError) do
      @subject.register_domain(@account_id, "example.com")
    end
  end


  test "get domain registration builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/.+/registrations/.+$})
        .to_return(read_http_fixture("getDomainRegistration/success.http"))

    @subject.get_domain_registration(@account_id, domain_name = "example.com", registration_id = 361)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/registrations/#{registration_id}",
                     headers: { "Accept" => "application/json" })
  end

  test "get domain registration returns the domain transfer" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/.+/registrations/.+$})
        .to_return(read_http_fixture("getDomainRegistration/success.http"))

    response = @subject.get_domain_registration(@account_id, "example.com", 361)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DomainRegistration, result)
    assert_kind_of(Integer, result.id)
    assert_kind_of(Integer, result.domain_id)
  end


  test "renew domain builds correct request" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/renewals$})
        .to_return(read_http_fixture("renewDomain/success.http"))

    attributes = { period: "3" }
    @subject.renew_domain(@account_id, domain_name = "example.com", attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/renewals",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  test "renew domain returns the domain" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/renewals$})
        .to_return(read_http_fixture("renewDomain/success.http"))

    attributes = { period: "3" }
    response = @subject.renew_domain(@account_id, "example.com", attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DomainRenewal, result)
    assert_kind_of(Integer, result.id)
    assert_kind_of(Integer, result.domain_id)
  end

  test "renew domain when too soon raises bad request error" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/renewals$})
        .to_return(read_http_fixture("renewDomain/error-tooearly.http"))

    attributes = { period: "3" }
    assert_raises(Dnsimple::RequestError) do
      @subject.renew_domain(@account_id, "example.com", attributes)
    end
  end


  test "get domain renewal builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/.+/renewals/.+$})
        .to_return(read_http_fixture("getDomainRenewal/success.http"))

    @subject.get_domain_renewal(@account_id, domain_name = "example.com", renewal_id = 361)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/renewals/#{renewal_id}",
                     headers: { "Accept" => "application/json" })
  end

  test "get domain renewal returns the domain renewal" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/.+/renewals/.+$})
        .to_return(read_http_fixture("getDomainRenewal/success.http"))

    response = @subject.get_domain_renewal(@account_id, "example.com", 361)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DomainRenewal, result)
    assert_kind_of(Integer, result.id)
    assert_kind_of(Integer, result.domain_id)
  end


  test "transfer domain builds correct request" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/transfers$})
        .to_return(read_http_fixture("transferDomain/success.http"))

    attributes = { registrant_id: "10", auth_code: "x1y2z3" }
    @subject.transfer_domain(@account_id, domain_name = "example.com", attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/transfers",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  test "transfer domain returns the domain" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/transfers$})
        .to_return(read_http_fixture("transferDomain/success.http"))

    attributes = { registrant_id: "10", auth_code: "x1y2z3" }
    response = @subject.transfer_domain(@account_id, "example.com", attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DomainTransfer, result)
    assert_kind_of(Integer, result.id)
    assert_kind_of(Integer, result.domain_id)
  end

  test "transfer domain when attributes are incomplete raises argument error" do
    assert_raises(ArgumentError) do
      @subject.transfer_domain(@account_id, "example.com", auth_code: "x1y2z3")
    end
  end

  test "transfer domain when domain is already in dnsimple raises bad request error" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/transfers$})
        .to_return(read_http_fixture("transferDomain/error-indnsimple.http"))

    attributes = { registrant_id: "10", auth_code: "x1y2z3" }
    assert_raises(Dnsimple::RequestError) do
      @subject.transfer_domain(@account_id, "example.com", attributes)
    end
  end

  test "transfer domain when auth code missing and required raises bad request error" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/transfers$})
        .to_return(read_http_fixture("transferDomain/error-missing-authcode.http"))

    assert_raises(Dnsimple::RequestError) do
      @subject.transfer_domain(@account_id, "example.com", registrant_id: 10)
    end
  end


  test "get domain transfer builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/.+/transfers/.+$})
        .to_return(read_http_fixture("getDomainTransfer/success.http"))

    @subject.get_domain_transfer(@account_id, domain_name = "example.com", transfer_id = 361)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/transfers/#{transfer_id}",
                     headers: { "Accept" => "application/json" })
  end

  test "get domain transfer returns the domain transfer" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/.+/transfers/.+$})
        .to_return(read_http_fixture("getDomainTransfer/success.http"))

    response = @subject.get_domain_transfer(@account_id, "example.com", 361)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DomainTransfer, result)
    assert_equal(361, result.id)
    assert_equal(182_245, result.domain_id)
    assert_equal(2715, result.registrant_id)
    assert_equal("cancelled", result.state)
    refute(result.auto_renew)
    refute(result.whois_privacy)
    assert_equal("Canceled by customer", result.status_description)
    assert_equal("2020-06-05T18:08:00Z", result.created_at)
    assert_equal("2020-06-05T18:10:01Z", result.updated_at)
  end


  test "cancel domain transfer builds correct request" do
    stub_request(:delete, %r{/v2/#{@account_id}/registrar/domains/.+/transfers/.+$})
        .to_return(read_http_fixture("cancelDomainTransfer/success.http"))

    @subject.cancel_domain_transfer(@account_id, domain_name = "example.com", transfer_id = 361)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/transfers/#{transfer_id}",
                     headers: { "Accept" => "application/json" })
  end

  test "cancel domain transfer returns the domain transfer" do
    stub_request(:delete, %r{/v2/#{@account_id}/registrar/domains/.+/transfers/.+$})
        .to_return(read_http_fixture("cancelDomainTransfer/success.http"))

    response = @subject.cancel_domain_transfer(@account_id, "example.com", 361)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DomainTransfer, result)
    assert_equal(361, result.id)
    assert_equal(182_245, result.domain_id)
    assert_equal(2715, result.registrant_id)
    assert_equal("transferring", result.state)
    refute(result.auto_renew)
    refute(result.whois_privacy)
    assert_nil(result.status_description)
    assert_equal("2020-06-05T18:08:00Z", result.created_at)
    assert_equal("2020-06-05T18:08:04Z", result.updated_at)
  end


  test "transfer domain out builds correct request" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/authorize_transfer_out$})
        .to_return(read_http_fixture("authorizeDomainTransferOut/success.http"))

    @subject.transfer_domain_out(@account_id, domain_name = "example.com")

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/authorize_transfer_out",
                     headers: { "Accept" => "application/json" })
  end

  test "transfer domain out returns nothing" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/authorize_transfer_out$})
        .to_return(read_http_fixture("authorizeDomainTransferOut/success.http"))

    response = @subject.transfer_domain_out(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end


  test "check registrant change builds correct request" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/registrant_changes/check$})
        .to_return(read_http_fixture("checkRegistrantChange/success.http"))

    attributes = { domain_id: "example.com", contact_id: 1234 }
    @subject.check_registrant_change(@account_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/registrar/registrant_changes/check",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  test "check registrant change returns the registrant change check" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/registrant_changes/check$})
        .to_return(read_http_fixture("checkRegistrantChange/success.http"))

    attributes = { domain_id: "example.com", contact_id: 1234 }
    response = @subject.check_registrant_change(@account_id, attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::RegistrantChangeCheck, result)
    assert_equal(101, result.contact_id)
    assert_equal(101, result.domain_id)
    assert_kind_of(Array, result.extended_attributes)
    assert_empty(result.extended_attributes)
    assert(result.registry_owner_change)
  end

  test "check registrant change when attributes are incomplete raises argument error" do
    assert_raises(ArgumentError) do
      @subject.check_registrant_change(@account_id, domain_id: "example.com")
    end
  end

  test "check registrant change when domain not found raises not found error" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/registrant_changes/check$})
        .to_return(read_http_fixture("checkRegistrantChange/error-domainnotfound.http"))

    attributes = { domain_id: "example.com", contact_id: 1234 }
    assert_raises(Dnsimple::NotFoundError) do
      @subject.check_registrant_change(@account_id, attributes)
    end
  end

  test "check registrant change when contact not found raises not found error" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/registrant_changes/check$})
        .to_return(read_http_fixture("checkRegistrantChange/error-contactnotfound.http"))

    attributes = { domain_id: "example.com", contact_id: 1234 }
    assert_raises(Dnsimple::NotFoundError) do
      @subject.check_registrant_change(@account_id, attributes)
    end
  end


  test "get registrant change builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/registrant_changes/.+$})
        .to_return(read_http_fixture("getRegistrantChange/success.http"))

    @subject.get_registrant_change(@account_id, registrant_change_id = 42)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/registrar/registrant_changes/#{registrant_change_id}",
                     headers: { "Accept" => "application/json" })
  end

  test "get registrant change returns the registrant change" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/registrant_changes/.+$})
        .to_return(read_http_fixture("getRegistrantChange/success.http"))

    response = @subject.get_registrant_change(@account_id, 42)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::RegistrantChange, result)
    assert_equal(101, result.id)
    assert_equal(101, result.account_id)
    assert_equal(101, result.contact_id)
    assert_equal(101, result.domain_id)
    assert_equal("new", result.state)
    assert_kind_of(Hash, result.extended_attributes)
    assert_empty(result.extended_attributes)
    assert(result.registry_owner_change)
    assert_nil(result.irt_lock_lifted_by)
    assert_equal("2017-02-03T17:43:22Z", result.created_at)
    assert_equal("2017-02-03T17:43:22Z", result.updated_at)
  end


  test "create registrant change builds correct request" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/registrant_changes$})
        .to_return(read_http_fixture("createRegistrantChange/success.http"))

    attributes = { domain_id: "example.com", contact_id: 1234, extended_attributes: { "x-fi-registrant-idnumber" => "1234" } }
    @subject.create_registrant_change(@account_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/registrar/registrant_changes",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  test "create registrant change returns the registrant change" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/registrant_changes$})
        .to_return(read_http_fixture("createRegistrantChange/success.http"))

    attributes = { domain_id: "example.com", contact_id: 1234, extended_attributes: { "x-fi-registrant-idnumber" => "1234" } }
    response = @subject.create_registrant_change(@account_id, attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::RegistrantChange, result)
    assert_equal(101, result.id)
    assert_equal(101, result.account_id)
    assert_equal(101, result.contact_id)
    assert_equal(101, result.domain_id)
    assert_equal("new", result.state)
    assert_kind_of(Hash, result.extended_attributes)
    assert_empty(result.extended_attributes)
    assert(result.registry_owner_change)
    assert_nil(result.irt_lock_lifted_by)
    assert_equal("2017-02-03T17:43:22Z", result.created_at)
    assert_equal("2017-02-03T17:43:22Z", result.updated_at)
  end

  test "create registrant change when attributes are incomplete raises argument error" do
    assert_raises(ArgumentError) do
      @subject.create_registrant_change(@account_id, domain_id: "example.com")
    end
  end

  test "create registrant change when domain not found raises not found error" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/registrant_changes$})
        .to_return(read_http_fixture("checkRegistrantChange/error-domainnotfound.http"))

    attributes = { domain_id: "example.com", contact_id: 1234, extended_attributes: { "x-fi-registrant-idnumber" => "1234" } }
    assert_raises(Dnsimple::NotFoundError) do
      @subject.create_registrant_change(@account_id, attributes)
    end
  end

  test "create registrant change when contact not found raises not found error" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/registrant_changes$})
        .to_return(read_http_fixture("checkRegistrantChange/error-contactnotfound.http"))

    attributes = { domain_id: "example.com", contact_id: 1234, extended_attributes: { "x-fi-registrant-idnumber" => "1234" } }
    assert_raises(Dnsimple::NotFoundError) do
      @subject.create_registrant_change(@account_id, attributes)
    end
  end


  test "list registrant changes builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/registrant_changes$})
        .to_return(read_http_fixture("listRegistrantChanges/success.http"))

    @subject.list_registrant_changes(@account_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/registrar/registrant_changes",
                     headers: { "Accept" => "application/json" })
  end

  test "list registrant changes returns the registrant changes" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/registrant_changes$})
        .to_return(read_http_fixture("listRegistrantChanges/success.http"))

    response = @subject.list_registrant_changes(@account_id)

    assert_kind_of(Dnsimple::PaginatedResponse, response)

    results = response.data

    results.each do |result|
      assert_kind_of(Dnsimple::Struct::RegistrantChange, result)
      assert_kind_of(Integer, result.id)
      assert_kind_of(Integer, result.account_id)
      assert_kind_of(Integer, result.contact_id)
      assert_kind_of(Integer, result.domain_id)
      assert_kind_of(String, result.state)
      assert_kind_of(Hash, result.extended_attributes)
      assert_empty(result.extended_attributes)
      assert_includes([true, false], result.registry_owner_change)
      assert_nil(result.irt_lock_lifted_by)
      assert_kind_of(String, result.created_at)
      assert_kind_of(String, result.updated_at)
    end
  end


  test "delete registrant change builds correct request" do
    stub_request(:delete, %r{/v2/#{@account_id}/registrar/registrant_changes/.+$})
        .to_return(read_http_fixture("deleteRegistrantChange/success.http"))

    @subject.delete_registrant_change(@account_id, registrant_change_id = 42)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/registrar/registrant_changes/#{registrant_change_id}",
                     headers: { "Accept" => "application/json" })
  end

  test "delete registrant change returns nothing" do
    stub_request(:delete, %r{/v2/#{@account_id}/registrar/registrant_changes/.+$})
        .to_return(read_http_fixture("deleteRegistrantChange/success.http"))

    response = @subject.delete_registrant_change(@account_id, 42)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end


  test "restore domain builds correct request" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/restores$})
        .to_return(read_http_fixture("restoreDomain/success.http"))

    @subject.restore_domain(@account_id, domain_name = "example.com", {})

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/restores",
                     headers: { "Accept" => "application/json" })
  end

  test "restore domain returns the domain" do
    stub_request(:post, %r{/v2/#{@account_id}/registrar/domains/.+/restores$})
        .to_return(read_http_fixture("restoreDomain/success.http"))

    response = @subject.restore_domain(@account_id, "example.com", {})

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DomainRestore, result)
    assert_kind_of(Integer, result.id)
    assert_kind_of(Integer, result.domain_id)
  end


  test "get domain restore builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/.+/restores/.+$})
        .to_return(read_http_fixture("getDomainRestore/success.http"))

    @subject.get_domain_restore(@account_id, domain_name = "example.com", restore_id = 361)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/registrar/domains/#{domain_name}/restores/#{restore_id}",
                     headers: { "Accept" => "application/json" })
  end

  test "get domain restore returns the domain restore" do
    stub_request(:get, %r{/v2/#{@account_id}/registrar/domains/.+/restores/.+$})
        .to_return(read_http_fixture("getDomainRestore/success.http"))

    response = @subject.get_domain_restore(@account_id, "example.com", 361)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DomainRestore, result)
    assert_kind_of(Integer, result.id)
    assert_kind_of(Integer, result.domain_id)
  end
end
