# frozen_string_literal: true

require "spec_helper"

describe Dnsimple::Client, ".registrar" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar }

  describe "#domain_delegation" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/.+/delegation$})
          .to_return(read_http_fixture("getDomainDelegation/success.http"))
    end

    it "builds the correct request" do
      subject.domain_delegation(account_id, domain_name = "example.com")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/delegation")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the name servers of the domain" do
      response = subject.domain_delegation(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      expect(response.data).to match_array(%w[ns1.dnsimple.com ns2.dnsimple.com ns3.dnsimple.com ns4.dnsimple.com])
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

      expect(WebMock).to have_requested(:put, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/delegation")
          .with(body: JSON.dump(attributes))
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the name servers of the domain" do
      response = subject.change_domain_delegation(account_id, "example.com", attributes)
      expect(response).to be_a(Dnsimple::Response)

      expect(response.data).to match_array(%w[ns1.dnsimple.com ns2.dnsimple.com ns3.dnsimple.com ns4.dnsimple.com])
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

      expect(WebMock).to have_requested(:put, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/delegation/vanity")
          .with(body: JSON.dump(attributes))
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns vanity name servers of the domain" do
      response = subject.change_domain_delegation_to_vanity(account_id, "example.com", attributes)
      expect(response).to be_a(Dnsimple::Response)

      vanity_name_server = response.data.first
      expect(vanity_name_server).to be_a(Dnsimple::Struct::VanityNameServer)
      expect(vanity_name_server.name).to eq("ns1.example.com")
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

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/delegation/vanity")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns empty response" do
      response = subject.change_domain_delegation_from_vanity(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end
  end
end
