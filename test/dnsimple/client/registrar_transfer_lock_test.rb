# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".registrar" do
  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar }

  describe "#get_domain_transfer_lock" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/#{domain_id}/transfer_lock})
          .to_return(read_http_fixture("getDomainTransferLock/success.http"))
    end

    it "builds the correct request" do
      subject.get_domain_transfer_lock(account_id, domain_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_id}/transfer_lock",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the transfer lock state" do
      response = subject.get_domain_transfer_lock(account_id, domain_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::TransferLock)
      _(result.enabled).must_equal(true)
    end

    describe "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        _ {
          subject.get_domain_transfer_lock(account_id, domain_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#enable_domain_transfer_lock" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/domains/#{domain_id}/transfer_lock})
          .to_return(read_http_fixture("enableDomainTransferLock/success.http"))
    end

    it "builds the correct request" do
      subject.enable_domain_transfer_lock(account_id, domain_id)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_id}/transfer_lock",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the transfer lock state" do
      response = subject.enable_domain_transfer_lock(account_id, domain_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::TransferLock)
      _(result.enabled).must_equal(true)
    end

    describe "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        _ {
          subject.enable_domain_transfer_lock(account_id, domain_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#disable_domain_transfer_lock" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/registrar/domains/#{domain_id}})
          .to_return(read_http_fixture("disableDomainTransferLock/success.http"))
    end

    it "builds the correct request" do
      subject.disable_domain_transfer_lock(account_id, domain_id)

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_id}/transfer_lock",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the transfer lock state" do
      response = subject.disable_domain_transfer_lock(account_id, domain_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::TransferLock)
      _(result.enabled).must_equal(false)
    end

    describe "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        _ {
          subject.disable_domain_transfer_lock(account_id, domain_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end
end
