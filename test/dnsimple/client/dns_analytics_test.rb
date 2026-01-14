# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".dns_analytics" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").dns_analytics }

  describe "#query" do
    before do
      stub_request(:get, %r{/v2/1/dns_analytics})
          .to_return(read_http_fixture("dnsAnalytics/success.http"))
    end

    it "builds the correct request" do
      subject.query(1)

      assert_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics",
                       headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.query(1, page: 2, per_page: 200)

      assert_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics?page=2&per_page=200")
    end

    it "supports sorting" do
      subject.query(1, sort: "date:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics?sort=date:asc")
    end

    it "supports filtering" do
      subject.query(1, filter: { start_date: "2024-08-01", end_date: "2024-09-01" })

      assert_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics?start_date=2024-08-01&end_date=2024-09-01")
    end

    it "supports groupings" do
      subject.query(1, groupings: "date,zone_name")

      assert_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics?groupings=date,zone_name")
    end


    it "returns a list of DNS Analytics entries" do
      response = subject.query(1)

      _(response).must_be_kind_of(Dnsimple::PaginatedResponseWithQuery)
      _(response.data).must_be_kind_of(Array)
      _(response.data.size).must_equal(12)

      _(response.data.all?(Dnsimple::Struct::DnsAnalytics)).must_equal(true)
      _(response.data[0].date).must_equal("2023-12-08")
      _(response.data[0].zone_name).must_equal("bar.com")
      _(response.data[0].volume).must_equal(1200)
    end

    it "exposes the pagination information" do
      response = subject.query(1)

      _(response).must_respond_to(:page)
      _(response.page).must_equal(0)
      _(response.per_page).must_equal(100)
      _(response.total_entries).must_equal(93)
      _(response.total_pages).must_equal(1)
    end

    it "exposes the query parameters applied to produce the results" do
      response = subject.query(1)

      _(response).must_respond_to(:query)
      query = response.query
      _(query["account_id"]).must_equal(1)
      _(query["start_date"]).must_equal("2023-12-08")
      _(query["end_date"]).must_equal("2024-01-08")
      _(query["sort"]).must_equal("zone_name:asc,date:asc")
      _(query["groupings"]).must_equal("zone_name,date")
      _(query["page"]).must_equal(0)
      _(query["per_page"]).must_equal(100)
    end
  end
end
