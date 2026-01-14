# frozen_string_literal: true

require "test_helper"

class ZonesDistributionsTest < Minitest::Test

  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").zones
    @account_id = 1010
    @zone_id = "example.com"
    @record_id = 5
  end

  def test_zone_distribution_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/zones/.+$})
        .to_return(read_http_fixture("checkZoneDistribution/success.http"))

    zone = "example.com"
    @subject.zone_distribution(@account_id, zone)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{zone}/distribution",
                     headers: { "Accept" => "application/json" })
  end

  def test_zone_distribution_returns_true_when_fully_distributed
    stub_request(:get, %r{/v2/#{@account_id}/zones/.+$})
        .to_return(read_http_fixture("checkZoneDistribution/success.http"))

    response = @subject.zone_distribution(@account_id, "example.com")
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::ZoneDistribution, result)
    assert_equal(true, result.distributed)
  end

  def test_zone_distribution_returns_false_when_not_fully_distributed
    stub_request(:get, %r{/v2/#{@account_id}/zones/.+$})
        .to_return(read_http_fixture("checkZoneDistribution/failure.http"))

    response = @subject.zone_distribution(@account_id, "example.com")
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::ZoneDistribution, result)
    assert_equal(false, result.distributed)
  end

  def test_zone_distribution_raises_error_when_check_fails
    stub_request(:get, %r{/v2/#{@account_id}/zones/.+$})
        .to_return(read_http_fixture("checkZoneDistribution/error.http"))

    error = assert_raises(Dnsimple::RequestError) do
      @subject.zone_distribution(@account_id, "example.com")
    end
    assert_equal("Could not query zone, connection timed out", error.message)
  end

  def test_zone_distribution_when_zone_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-zone.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.zone_distribution(@account_id, "example.com")
    end
  end

  def test_zone_record_distribution_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records/#{@record_id}/distribution$})
        .to_return(read_http_fixture("checkZoneRecordDistribution/success.http"))

    @subject.zone_record_distribution(@account_id, @zone_id, @record_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/records/#{@record_id}/distribution",
                     headers: { "Accept" => "application/json" })
  end

  def test_zone_record_distribution_returns_true_when_fully_distributed
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records/#{@record_id}/distribution$})
        .to_return(read_http_fixture("checkZoneRecordDistribution/success.http"))

    response = @subject.zone_record_distribution(@account_id, @zone_id, @record_id)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::ZoneDistribution, result)
    assert_equal(true, result.distributed)
  end

  def test_zone_record_distribution_returns_false_when_not_fully_distributed
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records/#{@record_id}/distribution$})
        .to_return(read_http_fixture("checkZoneRecordDistribution/failure.http"))

    response = @subject.zone_record_distribution(@account_id, @zone_id, @record_id)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::ZoneDistribution, result)
    assert_equal(false, result.distributed)
  end

  def test_zone_record_distribution_raises_error_when_check_fails
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records/#{@record_id}/distribution$})
        .to_return(read_http_fixture("checkZoneRecordDistribution/error.http"))

    error = assert_raises(Dnsimple::RequestError) do
      @subject.zone_record_distribution(@account_id, @zone_id, @record_id)
    end
    assert_equal("Could not query zone, connection timed out", error.message)
  end

  def test_zone_record_distribution_when_zone_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-zone.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.zone_record_distribution(@account_id, @zone_id, "0")
    end
  end

  def test_zone_record_distribution_when_record_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-record.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.zone_record_distribution(@account_id, @zone_id, "0")
    end
  end

end
