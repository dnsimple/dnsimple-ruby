# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".domains" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }

  describe "#enable_dnssec" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/dnssec})
          .to_return(read_http_fixture("enableDnssec/success.http"))
    end


    it "builds the correct request" do
      subject.enable_dnssec(account_id, domain_id)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/dnssec",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the dnssec status" do
      response = subject.enable_dnssec(account_id, domain_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Dnssec)
      _(result.enabled).must_equal(true)
    end

    describe "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        _ {
          subject.enable_dnssec(account_id, domain_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end

  end

  describe "#disable_dnssec" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/domains/#{domain_id}/dnssec})
          .to_return(read_http_fixture("disableDnssec/success.http"))
    end


    it "builds the correct request" do
      subject.disable_dnssec(account_id, domain_id)

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/dnssec",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.disable_dnssec(account_id, domain_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end

    describe "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        _ {
          subject.disable_dnssec(account_id, domain_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#get_dnssec" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/dnssec})
          .to_return(read_http_fixture("getDnssec/success.http"))
    end


    it "builds the correct request" do
      subject.get_dnssec(account_id, domain_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/dnssec",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the dnssec status" do
      response = subject.get_dnssec(account_id, domain_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Dnssec)
      _(result.enabled).must_equal(true)
    end

    describe "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        _ {
          subject.get_dnssec(account_id, domain_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end

  end

end
