# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".registrar" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar }


  describe "#enable_whois_privacy" do
    let(:account_id) { 1010 }

    describe "when the whois privacy had already been purchased" do
      before do
        stub_request(:put, %r{/v2/#{account_id}/registrar/domains/.+/whois_privacy$})
            .to_return(read_http_fixture("enableWhoisPrivacy/success.http"))
      end

      it "builds the correct request" do
        subject.enable_whois_privacy(account_id, domain_name = "example.com")

        assert_requested(:put, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/whois_privacy",
                         headers: { "Accept" => "application/json" })
      end

      it "returns the whois privacy" do
        response = subject.enable_whois_privacy(account_id, "example.com")
        _(response).must_be_kind_of(Dnsimple::Response)
        _(response.http_response.code).must_equal(200)

        result = response.data
        _(result).must_be_kind_of(Dnsimple::Struct::WhoisPrivacy)
        _(result.domain_id).must_be_kind_of(Integer)
        _(result.enabled).must_equal(true)
        _(result.expires_on).must_be_kind_of(String)
      end
    end

    describe "when the whois privacy is newly purchased" do
      before do
        stub_request(:put, %r{/v2/#{account_id}/registrar/domains/.+/whois_privacy$})
            .to_return(read_http_fixture("enableWhoisPrivacy/created.http"))
      end

      it "builds the correct request" do
        subject.enable_whois_privacy(account_id, domain_name = "example.com")

        assert_requested(:put, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/whois_privacy",
                         headers: { "Accept" => "application/json" })
      end

      it "returns the whois privacy" do
        response = subject.enable_whois_privacy(account_id, "example.com")
        _(response).must_be_kind_of(Dnsimple::Response)
        _(response.http_response.code).must_equal(201)

        result = response.data
        _(result).must_be_kind_of(Dnsimple::Struct::WhoisPrivacy)
        _(result.domain_id).must_be_kind_of(Integer)
        _(result.enabled).must_be_nil
        _(result.expires_on).must_be_nil
      end
    end
  end


  describe "#disable_whois_privacy" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/registrar/domains/.+/whois_privacy$})
          .to_return(read_http_fixture("disableWhoisPrivacy/success.http"))
    end

    it "builds the correct request" do
      subject.disable_whois_privacy(account_id, domain_name = "example.com")

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/whois_privacy",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the whois privacy" do
      response = subject.disable_whois_privacy(account_id, "example.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::WhoisPrivacy)
      _(result.domain_id).must_be_kind_of(Integer)
      _(result.enabled).must_equal(false)
      _(result.expires_on).must_be_kind_of(String)
    end
  end

end
