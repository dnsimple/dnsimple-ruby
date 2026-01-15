# frozen_string_literal: true

require "test_helper"

class DnsAnalyticsTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").dns_analytics
  end

  test "query builds correct request" do
    stub_request(:get, %r{/v2/1/dns_analytics})
        .to_return(read_http_fixture("dnsAnalytics/success.http"))

    @subject.query(1)

    assert_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics",
                     headers: { "Accept" => "application/json" })
  end

  test "query supports pagination" do
    stub_request(:get, %r{/v2/1/dns_analytics})
        .to_return(read_http_fixture("dnsAnalytics/success.http"))

    @subject.query(1, page: 2, per_page: 200)

    assert_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics?page=2&per_page=200")
  end

  test "query supports sorting" do
    stub_request(:get, %r{/v2/1/dns_analytics})
        .to_return(read_http_fixture("dnsAnalytics/success.http"))

    @subject.query(1, sort: "date:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics?sort=date:asc")
  end

  test "query supports filtering" do
    stub_request(:get, %r{/v2/1/dns_analytics})
        .to_return(read_http_fixture("dnsAnalytics/success.http"))

    @subject.query(1, filter: { start_date: "2024-08-01", end_date: "2024-09-01" })

    assert_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics?start_date=2024-08-01&end_date=2024-09-01")
  end

  test "query supports groupings" do
    stub_request(:get, %r{/v2/1/dns_analytics})
        .to_return(read_http_fixture("dnsAnalytics/success.http"))

    @subject.query(1, groupings: "date,zone_name")

    assert_requested(:get, "https://api.dnsimple.test/v2/1/dns_analytics?groupings=date,zone_name")
  end

  test "query returns dns analytics entries" do
    stub_request(:get, %r{/v2/1/dns_analytics})
        .to_return(read_http_fixture("dnsAnalytics/success.http"))

    response = @subject.query(1)

    assert_kind_of(Dnsimple::PaginatedResponseWithQuery, response)
    assert_kind_of(Array, response.data)
    assert_equal(12, response.data.size)

    assert(response.data.all?(Dnsimple::Struct::DnsAnalytics))
    assert_equal("2023-12-08", response.data[0].date)
    assert_equal("bar.com", response.data[0].zone_name)
    assert_equal(1200, response.data[0].volume)
  end

  test "query exposes pagination information" do
    stub_request(:get, %r{/v2/1/dns_analytics})
        .to_return(read_http_fixture("dnsAnalytics/success.http"))

    response = @subject.query(1)

    assert_respond_to(response, :page)
    assert_equal(0, response.page)
    assert_equal(100, response.per_page)
    assert_equal(93, response.total_entries)
    assert_equal(1, response.total_pages)
  end

  test "query exposes query parameters" do
    stub_request(:get, %r{/v2/1/dns_analytics})
        .to_return(read_http_fixture("dnsAnalytics/success.http"))

    response = @subject.query(1)

    assert_respond_to(response, :query)
    query = response.query

    assert_equal(1, query["account_id"])
    assert_equal("2023-12-08", query["start_date"])
    assert_equal("2024-01-08", query["end_date"])
    assert_equal("zone_name:asc,date:asc", query["sort"])
    assert_equal("zone_name,date", query["groupings"])
    assert_equal(0, query["page"])
    assert_equal(100, query["per_page"])
  end
end
