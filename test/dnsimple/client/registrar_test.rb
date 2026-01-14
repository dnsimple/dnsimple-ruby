# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".registrar" do
  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar }


  describe "#check_domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/.+/check$})
          .to_return(read_http_fixture("checkDomain/success.http"))
    end

    it "builds the correct request" do
      subject.check_domain(account_id, domain_name = "example.com")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/check",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the availability" do
      response = subject.check_domain(account_id, "example.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DomainCheck)
      _(result.domain).must_equal("ruby.codes")
      _(result.available).must_equal(true)
      _(result.premium).must_equal(true)
    end
  end

  describe "#get_domain_prices" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/bingo.pizza/prices$})
          .to_return(read_http_fixture("getDomainPrices/success.http"))
    end

    it "builds the correct request" do
      subject.get_domain_prices(account_id, "bingo.pizza")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/bingo.pizza/prices",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the prices" do
      response = subject.get_domain_prices(account_id, "bingo.pizza")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data

      _(result).must_be_kind_of(Dnsimple::Struct::DomainPrice)
      _(result.domain).must_equal("bingo.pizza")
      _(result.premium).must_equal(true)
      _(result.registration_price).must_equal(20.0)
      _(result.renewal_price).must_equal(20.0)
      _(result.transfer_price).must_equal(20.0)
    end

    describe "when the TLD is not supported" do
      before do
        stub_request(:get, %r{/v2/#{account_id}/registrar/domains/bingo.pineapple/prices$})
            .to_return(read_http_fixture("getDomainPrices/failure.http"))
      end

      it "raises error" do
        _ {
          subject.get_domain_prices(account_id, "bingo.pineapple")
        }.must_raise(Dnsimple::RequestError)
      end
    end
  end

  describe "#register_domain" do
    let(:account_id) { 1010 }
    let(:attributes) { { registrant_id: "10" } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/registrations$})
          .to_return(read_http_fixture("registerDomain/success.http"))
    end


    it "builds the correct request" do
      subject.register_domain(account_id, domain_name = "example.com", attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/registrations",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the domain" do
      response = subject.register_domain(account_id, "example.com", attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DomainRegistration)
      _(result.id).must_be_kind_of(Integer)
      _(result.domain_id).must_be_kind_of(Integer)
    end

    describe "when the attributes are incomplete" do
      it "raises ArgumentError" do
        _ { subject.register_domain(account_id, "example.com") }.must_raise(ArgumentError)
      end
    end
  end

  describe "#get_domain_registration" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/.+/registrations/.+$})
          .to_return(read_http_fixture("getDomainRegistration/success.http"))
    end

    it "builds the correct request" do
      subject.get_domain_registration(account_id, domain_name = "example.com", registration_id = 361)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/registrations/#{registration_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the domain transfer" do
      response = subject.get_domain_registration(account_id, "example.com", 361)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DomainRegistration)
      _(result.id).must_be_kind_of(Integer)
      _(result.domain_id).must_be_kind_of(Integer)
    end
  end

  describe "#renew_domain" do
    let(:account_id) { 1010 }
    let(:attributes) { { period: "3" } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/renewals$})
          .to_return(read_http_fixture("renewDomain/success.http"))
    end


    it "builds the correct request" do
      subject.renew_domain(account_id, domain_name = "example.com", attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/renewals",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the domain" do
      response = subject.renew_domain(account_id, "example.com", attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DomainRenewal)
      _(result.id).must_be_kind_of(Integer)
      _(result.domain_id).must_be_kind_of(Integer)
    end

    describe "when it is too soon for the domain to be renewed" do
      it "raises a BadRequestError" do
        stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/renewals$})
            .to_return(read_http_fixture("renewDomain/error-tooearly.http"))

        _ {
          subject.renew_domain(account_id, "example.com", attributes)
        }.must_raise(Dnsimple::RequestError)
      end
    end
  end

  describe "#get_domain_renewal" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/.+/renewals/.+$})
          .to_return(read_http_fixture("getDomainRenewal/success.http"))
    end

    it "builds the correct request" do
      subject.get_domain_renewal(account_id, domain_name = "example.com", renewal_id = 361)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/renewals/#{renewal_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the domain renewal" do
      response = subject.get_domain_renewal(account_id, "example.com", 361)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DomainRenewal)
      _(result.id).must_be_kind_of(Integer)
      _(result.domain_id).must_be_kind_of(Integer)
    end
  end

  describe "#transfer_domain" do
    let(:account_id) { 1010 }
    let(:attributes) { { registrant_id: "10", auth_code: "x1y2z3" } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/transfers$})
          .to_return(read_http_fixture("transferDomain/success.http"))
    end


    it "builds the correct request" do
      subject.transfer_domain(account_id, domain_name = "example.com", attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/transfers",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the domain" do
      response = subject.transfer_domain(account_id, "example.com", attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DomainTransfer)
      _(result.id).must_be_kind_of(Integer)
      _(result.domain_id).must_be_kind_of(Integer)
    end

    describe "when the attributes are incomplete" do
      it "raises ArgumentError" do
        _ { subject.transfer_domain(account_id, "example.com", auth_code: "x1y2z3") }.must_raise(ArgumentError)
      end
    end

    describe "when the domain is already in DNSimple" do
      it "raises a BadRequestError" do
        stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/transfers$})
            .to_return(read_http_fixture("transferDomain/error-indnsimple.http"))

        _ {
          subject.transfer_domain(account_id, "example.com", attributes)
        }.must_raise(Dnsimple::RequestError)
      end
    end

    describe "when :auth_code wasn't provided and is required by the TLD" do
      it "raises a BadRequestError" do
        stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/transfers$})
            .to_return(read_http_fixture("transferDomain/error-missing-authcode.http"))

        _ {
          subject.transfer_domain(account_id, "example.com", registrant_id: 10)
        }.must_raise(Dnsimple::RequestError)
      end
    end
  end

  describe "#get_transfer_domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/.+/transfers/.+$})
          .to_return(read_http_fixture("getDomainTransfer/success.http"))
    end

    it "builds the correct request" do
      subject.get_domain_transfer(account_id, domain_name = "example.com", transfer_id = 361)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/transfers/#{transfer_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the domain transfer" do
      response = subject.get_domain_transfer(account_id, "example.com", 361)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DomainTransfer)
      _(result.id).must_equal(361)
      _(result.domain_id).must_equal(182_245)
      _(result.registrant_id).must_equal(2715)
      _(result.state).must_equal("cancelled")
      _(result.auto_renew).must_equal(false)
      _(result.whois_privacy).must_equal(false)
      _(result.status_description).must_equal("Canceled by customer")
      _(result.created_at).must_equal("2020-06-05T18:08:00Z")
      _(result.updated_at).must_equal("2020-06-05T18:10:01Z")
    end
  end

  describe "#cancel_domain_transfer" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/registrar/domains/.+/transfers/.+$})
          .to_return(read_http_fixture("cancelDomainTransfer/success.http"))
    end

    it "builds the correct request" do
      subject.cancel_domain_transfer(account_id, domain_name = "example.com", transfer_id = 361)

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/transfers/#{transfer_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the domain transfer" do
      response = subject.cancel_domain_transfer(account_id, "example.com", 361)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DomainTransfer)
      _(result.id).must_equal(361)
      _(result.domain_id).must_equal(182_245)
      _(result.registrant_id).must_equal(2715)
      _(result.state).must_equal("transferring")
      _(result.auto_renew).must_equal(false)
      _(result.whois_privacy).must_equal(false)
      _(result.status_description).must_be_nil
      _(result.created_at).must_equal("2020-06-05T18:08:00Z")
      _(result.updated_at).must_equal("2020-06-05T18:08:04Z")
    end
  end


  describe "#transfer_domain_out" do
    let(:account_id) { 1010 }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/authorize_transfer_out$})
          .to_return(read_http_fixture("authorizeDomainTransferOut/success.http"))
    end

    it "builds the correct request" do
      subject.transfer_domain_out(account_id, domain_name = "example.com")

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/authorize_transfer_out",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.transfer_domain_out(account_id, "example.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end
  end

  describe "#check_registrant_change" do
    let(:account_id) { 1010 }
    let(:attributes) { { domain_id: "example.com", contact_id: 1234 } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/registrant_changes/check$})
          .to_return(read_http_fixture("checkRegistrantChange/success.http"))
    end

    it "builds the correct request" do
      subject.check_registrant_change(account_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/registrant_changes/check",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the registrant change check" do
      response = subject.check_registrant_change(account_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::RegistrantChangeCheck)
      _(result.contact_id).must_equal(101)
      _(result.domain_id).must_equal(101)
      _(result.extended_attributes).must_be_kind_of(Array)
      _(result.extended_attributes).must_be_empty
      _(result.registry_owner_change).must_equal(true)
    end

    describe "when the attributes are incomplete" do
      it "raises ArgumentError" do
        _ { subject.check_registrant_change(account_id, domain_id: "example.com") }.must_raise(ArgumentError)
      end
    end

    describe "when the domain is not found" do
      it "raises a NotFoundError" do
        stub_request(:post, %r{/v2/#{account_id}/registrar/registrant_changes/check$})
            .to_return(read_http_fixture("checkRegistrantChange/error-domainnotfound.http"))

        _ {
          subject.check_registrant_change(account_id, attributes)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end

    describe "when the contact is not found" do
      it "raises a NotFoundError" do
        stub_request(:post, %r{/v2/#{account_id}/registrar/registrant_changes/check$})
            .to_return(read_http_fixture("checkRegistrantChange/error-contactnotfound.http"))

        _ {
          subject.check_registrant_change(account_id, attributes)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#get_registrant_change" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/registrant_changes/.+$})
          .to_return(read_http_fixture("getRegistrantChange/success.http"))
    end

    it "builds the correct request" do
      subject.get_registrant_change(account_id, registrant_change_id = 42)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/registrant_changes/#{registrant_change_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the registrant change" do
      response = subject.get_registrant_change(account_id, 42)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::RegistrantChange)
      _(result.id).must_equal(101)
      _(result.account_id).must_equal(101)
      _(result.contact_id).must_equal(101)
      _(result.domain_id).must_equal(101)
      _(result.state).must_equal("new")
      _(result.extended_attributes).must_be_kind_of(Hash)
      _(result.extended_attributes).must_be_empty
      _(result.registry_owner_change).must_equal(true)
      _(result.irt_lock_lifted_by).must_be_nil
      _(result.created_at).must_equal("2017-02-03T17:43:22Z")
      _(result.updated_at).must_equal("2017-02-03T17:43:22Z")
    end
  end

  describe "#create_registrant_change" do
    let(:account_id) { 1010 }
    let(:attributes) { { domain_id: "example.com", contact_id: 1234, extended_attributes: { "x-fi-registrant-idnumber" => "1234" } } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/registrant_changes$})
          .to_return(read_http_fixture("createRegistrantChange/success.http"))
    end

    it "builds the correct request" do
      subject.create_registrant_change(account_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/registrant_changes",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the registrant change" do
      response = subject.create_registrant_change(account_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::RegistrantChange)
      _(result.id).must_equal(101)
      _(result.account_id).must_equal(101)
      _(result.contact_id).must_equal(101)
      _(result.domain_id).must_equal(101)
      _(result.state).must_equal("new")
      _(result.extended_attributes).must_be_kind_of(Hash)
      _(result.extended_attributes).must_be_empty
      _(result.registry_owner_change).must_equal(true)
      _(result.irt_lock_lifted_by).must_be_nil
      _(result.created_at).must_equal("2017-02-03T17:43:22Z")
      _(result.updated_at).must_equal("2017-02-03T17:43:22Z")
    end

    describe "when the attributes are incomplete" do
      it "raises ArgumentError" do
        _ { subject.create_registrant_change(account_id, domain_id: "example.com") }.must_raise(ArgumentError)
      end
    end

    describe "when the domain is not found" do
      it "raises a NotFoundError" do
        stub_request(:post, %r{/v2/#{account_id}/registrar/registrant_changes$})
            .to_return(read_http_fixture("checkRegistrantChange/error-domainnotfound.http"))

        _ {
          subject.create_registrant_change(account_id, attributes)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end

    describe "when the contact is not found" do
      it "raises a NotFoundError" do
        stub_request(:post, %r{/v2/#{account_id}/registrar/registrant_changes$})
            .to_return(read_http_fixture("checkRegistrantChange/error-contactnotfound.http"))

        _ {
          subject.create_registrant_change(account_id, attributes)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#list_registrant_changes" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/registrant_changes$})
          .to_return(read_http_fixture("listRegistrantChanges/success.http"))
    end

    it "builds the correct request" do
      subject.list_registrant_changes(account_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/registrant_changes",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the registrant changes" do
      response = subject.list_registrant_changes(account_id)
      _(response).must_be_kind_of(Dnsimple::PaginatedResponse)

      results = response.data

      results.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::RegistrantChange)
        _(result.id).must_be_kind_of(Integer)
        _(result.account_id).must_be_kind_of(Integer)
        _(result.contact_id).must_be_kind_of(Integer)
        _(result.domain_id).must_be_kind_of(Integer)
        _(result.state).must_be_kind_of(String)
        _(result.extended_attributes).must_be_kind_of(Hash)
        _(result.extended_attributes).must_be_empty
        _([true, false]).must_include(result.registry_owner_change)
        _(result.irt_lock_lifted_by).must_be_nil
        _(result.created_at).must_be_kind_of(String)
        _(result.updated_at).must_be_kind_of(String)
      end
    end
  end

  describe "#delete_registrant_change" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/registrar/registrant_changes/.+$})
          .to_return(read_http_fixture("deleteRegistrantChange/success.http"))
    end

    it "builds the correct request" do
      subject.delete_registrant_change(account_id, registrant_change_id = 42)

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/registrar/registrant_changes/#{registrant_change_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.delete_registrant_change(account_id, 42)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end
  end

  describe "#restore_domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/restores$})
          .to_return(read_http_fixture("restoreDomain/success.http"))
    end


    it "builds the correct request" do
      subject.restore_domain(account_id, domain_name = "example.com", {})

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/restores",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the domain" do
      response = subject.restore_domain(account_id, "example.com", {})
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DomainRestore)
      _(result.id).must_be_kind_of(Integer)
      _(result.domain_id).must_be_kind_of(Integer)
    end
  end

  describe "#get_domain_restore" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/.+/restores/.+$})
          .to_return(read_http_fixture("getDomainRestore/success.http"))
    end

    it "builds the correct request" do
      subject.get_domain_restore(account_id, domain_name = "example.com", restore_id = 361)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/restores/#{restore_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the domain restore" do
      response = subject.get_domain_restore(account_id, "example.com", 361)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DomainRestore)
      _(result.id).must_be_kind_of(Integer)
      _(result.domain_id).must_be_kind_of(Integer)
    end
  end
end
