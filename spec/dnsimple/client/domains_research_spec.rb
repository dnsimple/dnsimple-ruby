# frozen_string_literal: true

require "spec_helper"

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }

  describe "#domain_research_status" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/research/status})
          .with(query: { domain: "example.com" })
          .to_return(read_http_fixture("domainResearchStatus/success.http"))
    end

    it "builds the correct request" do
      subject.domain_research_status(account_id, domain_name = "example.com")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/research/status")
          .with(query: { domain: domain_name })
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the domain research status" do
      response = subject.domain_research_status(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DomainResearch)
      expect(result.request_id).to eq("f453dabc-a27e-4bf1-a93e-f263577ffaae")
      expect(result.domain).to eq("example.com")
      expect(result.availability).to eq("unavailable")
      expect(result.errors).to eq([])
    end
  end
end
