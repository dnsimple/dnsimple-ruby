# frozen_string_literal: true

require "spec_helper"

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }

  describe "#domain_research_status" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/research/status})
          .with(query: { domain: "taken.com" })
          .to_return(read_http_fixture("getDomainsResearchStatus/success-unavailable.http"))
    end

    it "builds the correct request" do
      subject.domain_research_status(account_id, domain_name = "taken.com")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/research/status")
          .with(query: { domain: domain_name })
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the domain research status" do
      response = subject.domain_research_status(account_id, "taken.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DomainResearchStatus)
      expect(result.request_id).to eq("25dd77cb-2f71-48b9-b6be-1dacd2881418")
      expect(result.domain).to eq("taken.com")
      expect(result.availability).to eq("unavailable")
      expect(result.errors).to eq([])
    end
  end
end
