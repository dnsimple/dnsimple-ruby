# frozen_string_literal: true

require "test_helper"

class ZonesTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").zones
    @account_id = 1010
  end

  def test_zones_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/zones})
        .to_return(read_http_fixture("listZones/success.http"))

    @subject.zones(@account_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones",
                     headers: { "Accept" => "application/json" })
  end

  def test_zones_supports_pagination
    stub_request(:get, %r{/v2/#{@account_id}/zones})
        .to_return(read_http_fixture("listZones/success.http"))

    @subject.zones(@account_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones?page=2")
  end

  def test_zones_supports_extra_request_options
    stub_request(:get, %r{/v2/#{@account_id}/zones})
        .to_return(read_http_fixture("listZones/success.http"))

    @subject.zones(@account_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones?foo=bar")
  end

  def test_zones_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/zones})
        .to_return(read_http_fixture("listZones/success.http"))

    @subject.zones(@account_id, sort: "name:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones?sort=name:desc")
  end

  def test_zones_supports_filtering
    stub_request(:get, %r{/v2/#{@account_id}/zones})
        .to_return(read_http_fixture("listZones/success.http"))

    @subject.zones(@account_id, filter: { name_like: "example" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones?name_like=example")
  end

  def test_zones_returns_the_zones
    stub_request(:get, %r{/v2/#{@account_id}/zones})
        .to_return(read_http_fixture("listZones/success.http"))

    response = @subject.zones(@account_id)

    assert_kind_of(Dnsimple::PaginatedResponse, response)
    assert_kind_of(Array, response.data)
    assert_equal(2, response.data.size)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::Zone, result)
      assert_kind_of(Integer, result.id)
    end
  end

  def test_zones_exposes_pagination_information
    stub_request(:get, %r{/v2/#{@account_id}/zones})
        .to_return(read_http_fixture("listZones/success.http"))

    response = @subject.zones(@account_id)

    assert_respond_to(response, :page)
    assert_equal(1, response.page)
    assert_kind_of(Integer, response.per_page)
    assert_kind_of(Integer, response.total_entries)
    assert_kind_of(Integer, response.total_pages)
  end

  def test_all_zones_delegates_to_paginate
    stub_request(:get, %r{/v2/#{@account_id}/zones})
        .to_return(read_http_fixture("listZones/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:zones, @account_id, { foo: "bar" }])
    @subject.stub(:paginate, mock) do
      @subject.all_zones(@account_id, { foo: "bar" })
    end
    mock.verify
  end

  def test_all_zones_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/zones})
        .to_return(read_http_fixture("listZones/success.http"))

    @subject.all_zones(@account_id, sort: "name:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones?page=1&per_page=100&sort=name:desc")
  end

  def test_all_zones_supports_filtering
    stub_request(:get, %r{/v2/#{@account_id}/zones})
        .to_return(read_http_fixture("listZones/success.http"))

    @subject.all_zones(@account_id, filter: { name_like: "zone.test" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones?page=1&per_page=100&name_like=zone.test")
  end

  def test_zone_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/zones/.+$})
        .to_return(read_http_fixture("getZone/success.http"))

    zone = "example.com"
    @subject.zone(@account_id, zone)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{zone}",
                     headers: { "Accept" => "application/json" })
  end

  def test_zone_returns_the_zone
    stub_request(:get, %r{/v2/#{@account_id}/zones/.+$})
        .to_return(read_http_fixture("getZone/success.http"))

    response = @subject.zone(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Zone, result)
    assert_equal(1, result.id)
    assert_equal(1010, result.account_id)
    assert_equal("example-alpha.com", result.name)
    refute(result.reverse)
    refute(result.secondary)
    assert_nil(result.last_transferred_at)
    assert(result.active)
    assert_equal("2015-04-23T07:40:03Z", result.created_at)
    assert_equal("2015-04-23T07:40:03Z", result.updated_at)
  end

  def test_zone_when_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-zone.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.zone(@account_id, "example.com")
    end
  end

  def test_zone_file_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/zones/.+$})
        .to_return(read_http_fixture("getZoneFile/success.http"))

    zone = "example.com"
    @subject.zone_file(@account_id, zone)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{zone}/file",
                     headers: { "Accept" => "application/json" })
  end

  def test_zone_file_returns_the_zone_file
    stub_request(:get, %r{/v2/#{@account_id}/zones/.+$})
        .to_return(read_http_fixture("getZoneFile/success.http"))

    response = @subject.zone_file(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::ZoneFile, result)
    assert_equal("$ORIGIN example.com.\n$TTL 1h\nexample.com. 3600 IN SOA ns1.dnsimple.com. admin.dnsimple.com. 1453132552 86400 7200 604800 300\nexample.com. 3600 IN NS ns1.dnsimple.com.\nexample.com. 3600 IN NS ns2.dnsimple.com.\nexample.com. 3600 IN NS ns3.dnsimple.com.\nexample.com. 3600 IN NS ns4.dnsimple.com.\n", result.zone)
  end

  def test_zone_file_when_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-zone.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.zone_file(@account_id, "example.com")
    end
  end

  def test_activate_dns_builds_correct_request
    stub_request(:put, %r{/v2/#{@account_id}/zones/.+/activation})
        .to_return(read_http_fixture("activateZoneService/success.http"))

    zone = "example.com"
    @subject.activate_dns(@account_id, zone)

    assert_requested(:put, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{zone}/activation",
                     headers: { "Accept" => "application/json" })
  end

  def test_activate_dns_returns_the_zone
    stub_request(:put, %r{/v2/#{@account_id}/zones/.+/activation})
        .to_return(read_http_fixture("activateZoneService/success.http"))

    response = @subject.activate_dns(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Zone, result)
    assert_equal(1, result.id)
    assert_equal(1010, result.account_id)
    assert_equal("example.com", result.name)
    refute(result.reverse)
    assert(result.active)
    assert_equal("2022-09-28T04:45:24Z", result.created_at)
    assert_equal("2023-07-06T11:19:48Z", result.updated_at)
  end

  def test_activate_dns_when_not_found_raises_not_found_error
    stub_request(:put, %r{/v2})
        .to_return(read_http_fixture("notfound-zone.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.activate_dns(@account_id, "example.com")
    end
  end

  def test_deactivate_dns_builds_correct_request
    stub_request(:delete, %r{/v2/#{@account_id}/zones/.+/activation})
        .to_return(read_http_fixture("deactivateZoneService/success.http"))

    zone = "example.com"
    @subject.deactivate_dns(@account_id, zone)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{zone}/activation",
                     headers: { "Accept" => "application/json" })
  end

  def test_deactivate_dns_returns_the_zone
    stub_request(:delete, %r{/v2/#{@account_id}/zones/.+/activation})
        .to_return(read_http_fixture("deactivateZoneService/success.http"))

    response = @subject.deactivate_dns(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Zone, result)
    assert_equal(1, result.id)
    assert_equal(1010, result.account_id)
    assert_equal("example.com", result.name)
    refute(result.reverse)
    refute(result.active)
    assert_equal("2022-09-28T04:45:24Z", result.created_at)
    assert_equal("2023-08-08T04:19:52Z", result.updated_at)
  end

  def test_deactivate_dns_when_not_found_raises_not_found_error
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-zone.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.deactivate_dns(@account_id, "example.com")
    end
  end
end
