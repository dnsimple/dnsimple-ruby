# frozen_string_literal: true

require 'spec_helper'

describe Dnsimple::Client, ".dns_analytics" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").dns_analytics }

  describe "#query" do
    before do
      stub_request(:get, %r{/v2/1/dns_analytics})
          .to_return(read_http_fixture("dnsAnalytics/success.http"))
    end

    it "builds the correct request" do
      subject.query(1)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.query(1, page: 2, per_page: 200)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics?page=2&per_page=200")
    end

    it "supports sorting" do
      subject.query(1, sort: "date:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics?sort=date:asc")
    end

    it "supports filtering" do
      subject.query(1, filter: { start_date: '2024-08-01', end_date: '2024-09-01' })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics?start_date=2024-08-01&end_date=2024-09-01")
    end

    it "supports groupings" do
      subject.query(1, groupings: 'date,zone_name')

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics?groupings=date,zone_name")
    end


    it "returns a list of DNS Analytics entries" do
      response = subject.query(1)

      expect(response).to be_a(Dnsimple::PaginatedResponseWithQuery)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(12)

      expect(response.data.all?(Dnsimple::Struct::DnsAnalytics)).to be(true)
      expect(response.data[0].date).to eq('2023-12-08')
      expect(response.data[0].zone_name).to eq('bar.com')
      expect(response.data[0].volume).to eq(1200)
    end

    it "exposes the pagination information" do
      response = subject.query(1)

      expect(response.respond_to?(:page)).to be(true)
      expect(response.page).to eq(0)
      expect(response.per_page).to eq(100)
      expect(response.total_entries).to eq(93)
      expect(response.total_pages).to eq(1)
    end

    it "exposes the query parameters applied to produce the results" do
      response = subject.query(1)

      expect(response.respond_to?(:query)).to be(true)
      query = response.query
      expect(query["account_id"]).to eq("1")
      expect(query["start_date"]).to eq('2023-12-08')
      expect(query["end_date"]).to eq('2024-01-08')
      expect(query["sort"]).to eq("zone_name:asc,date:asc")
      expect(query["groupings"]).to eq("zone_name,date")
      expect(query["page"]).to eq(0)
      expect(query["per_page"]).to eq(100)
    end
  end
end
