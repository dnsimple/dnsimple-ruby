require 'spec_helper'

describe Dnsimple::Client, ".nameservers / vanity_name_servers" do
  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").name_servers }

  describe "#enable_vanity_name_servers" do
    before do
      stub_request(:post, %r[/v1/domains/.+/vanity_name_servers]).
          to_return(read_fixture("nameservers/vanity_name_servers/enabled.http"))
    end

    it "builds the correct request" do
      subject.enable_vanity_name_servers("example.com", { "ns1" => "ns1.example.com", "ns2" => "ns2.example.com" })

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/example.com/vanity_name_servers").
                             with(body: { "vanity_nameserver_configuration" => { "server_source" => "external", "ns1" => "ns1.example.com", "ns2" => "ns2.example.com" } }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.enable_vanity_name_servers("example.com", { ns1: "ns1.example.com", ns2: "ns2.example.com" })

      expect(result).to be_truthy
    end
  end

  describe "#disable_vanity_name_servers" do
    before do
      stub_request(:delete, %r[/v1/domains/.+/vanity_name_servers]).
          to_return(read_fixture("nameservers/vanity_name_servers/disabled.http"))
    end

    it "builds the correct request" do
      subject.disable_vanity_name_servers("example.com")

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/domains/example.com/vanity_name_servers").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.disable_vanity_name_servers("example.com")

      expect(result).to be_truthy
    end
  end
end
