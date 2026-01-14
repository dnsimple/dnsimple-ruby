# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".registrar" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar }

  describe "#domain_delegation" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/.+/delegation$})
          .to_return(read_http_fixture("getDomainDelegation/success.http"))
    end

    it "builds the correct request" do
      subject.domain_delegation(account_id, domain_name = "example.com")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/delegation",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the name servers of the domain" do
      response = subject.domain_delegation(account_id, "example.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      _(response.data.sort).must_equal(%w[ns1.dnsimple.com ns2.dnsimple.com ns3.dnsimple.com ns4.dnsimple.com].sort)
    end
  end

  describe "#change_domain_delegation" do
    let(:account_id) { 1010 }
    let(:attributes) { %w[ns1.dnsimple.com ns2.dnsimple.com ns3.dnsimple.com ns4.dnsimple.com] }

    before do
      stub_request(:put, %r{/v2/#{account_id}/registrar/domains/.+/delegation$})
          .to_return(read_http_fixture("changeDomainDelegation/success.http"))
    end


    it "builds the correct request" do
      subject.change_domain_delegation(account_id, domain_name = "example.com", attributes)

      assert_requested(:put, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/delegation",
                       body: JSON.dump(attributes),
                       headers: { "Accept" => "application/json" })
    end

    it "returns the name servers of the domain" do
      response = subject.change_domain_delegation(account_id, "example.com", attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      _(response.data.sort).must_equal(%w[ns1.dnsimple.com ns2.dnsimple.com ns3.dnsimple.com ns4.dnsimple.com].sort)
    end
  end

  describe "#change_domain_delegation_to_vanity" do
    let(:account_id) { 1010 }
    let(:attributes) { %w[ns1.example.com ns2.example.com] }

    before do
      stub_request(:put, %r{/v2/#{account_id}/registrar/domains/.+/delegation/vanity$})
          .to_return(read_http_fixture("changeDomainDelegationToVanity/success.http"))
    end


    it "builds the correct request" do
      subject.change_domain_delegation_to_vanity(account_id, domain_name = "example.com", attributes)

      assert_requested(:put, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/delegation/vanity",
                       body: JSON.dump(attributes),
                       headers: { "Accept" => "application/json" })
    end

    it "returns vanity name servers of the domain" do
      response = subject.change_domain_delegation_to_vanity(account_id, "example.com", attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      vanity_name_server = response.data.first
      _(vanity_name_server).must_be_kind_of(Dnsimple::Struct::VanityNameServer)
      _(vanity_name_server.name).must_equal("ns1.example.com")
    end
  end

  describe "#change_domain_delegation_from_vanity" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/registrar/domains/.+/delegation/vanity$})
          .to_return(read_http_fixture("changeDomainDelegationFromVanity/success.http"))
    end

    it "builds the correct request" do
      subject.change_domain_delegation_from_vanity(account_id, domain_name = "example.com")

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/delegation/vanity",
                       headers: { "Accept" => "application/json" })
    end

    it "returns empty response" do
      response = subject.change_domain_delegation_from_vanity(account_id, "example.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end
  end
end
