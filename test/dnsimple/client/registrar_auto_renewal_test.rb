# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".registrar" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar }

  describe "#enable_auto_renewal" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:put, %r{/v2/#{account_id}/registrar/domains/#{domain_id}})
          .to_return(read_http_fixture("enableDomainAutoRenewal/success.http"))
    end


    it "builds the correct request" do
      subject.enable_auto_renewal(account_id, domain_id)

      assert_requested(:put, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_id}/auto_renewal",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.enable_auto_renewal(account_id, domain_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end

    describe "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:put, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        _ {
          subject.enable_auto_renewal(account_id, domain_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#disable_auto_renewal" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/registrar/domains/#{domain_id}})
          .to_return(read_http_fixture("disableDomainAutoRenewal/success.http"))
    end


    it "builds the correct request" do
      subject.disable_auto_renewal(account_id, domain_id)

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_id}/auto_renewal",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.disable_auto_renewal(account_id, domain_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end

    describe "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        _ {
          subject.disable_auto_renewal(account_id, domain_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end
end
