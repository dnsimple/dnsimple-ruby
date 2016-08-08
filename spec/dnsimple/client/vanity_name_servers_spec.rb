require 'spec_helper'

describe Dnsimple::Client, ".vanity_name_servers" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").vanity_name_servers }

  describe "#enable_vanity_name_servers" do
    let(:account_id) { 1010 }

    before do
      stub_request(:put, %r{/v2/#{account_id}/vanity/.+$}).
          to_return(read_http_fixture("enableVanityNameServers/success.http"))
    end

    it "builds the correct request" do
      subject.enable_vanity_name_servers(account_id, domain_name = "example.com")

      expect(WebMock).to have_requested(:put, "https://api.dnsimple.test/v2/#{account_id}/vanity/#{domain_name}").
          with(headers: { "Accept" => "application/json" })
    end

    it "returns vanity name servers of the domain" do
      response = subject.enable_vanity_name_servers(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      vanity_name_servers = response.data.map { |ns| ns["name"] }
      expect(vanity_name_servers).to match_array(%w(ns1.example.com ns2.example.com ns3.example.com ns4.example.com))
    end
  end

  describe "#disable_vanity_name_servers" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/vanity/.+$}).
          to_return(read_http_fixture("disableVanityNameServers/success.http"))
    end

    it "builds the correct request" do
      subject.disable_vanity_name_servers(account_id, domain_name = "example.com")

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/vanity/#{domain_name}").
          with(headers: { "Accept" => "application/json" })
    end

    it "returns empty response" do
      response = subject.disable_vanity_name_servers(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end
  end
end
