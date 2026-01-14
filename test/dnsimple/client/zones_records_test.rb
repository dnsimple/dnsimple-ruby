# frozen_string_literal: true

require "test_helper"

class ZonesRecordsTest < Minitest::Test

  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").zones
    @account_id = 1010
    @zone_id = "example.com"
  end

  def test_list_zone_records_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records})
        .to_return(read_http_fixture("listZoneRecords/success.http"))

    @subject.list_zone_records(@account_id, @zone_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/records",
                     headers: { "Accept" => "application/json" })
  end

  def test_list_zone_records_supports_pagination
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records})
        .to_return(read_http_fixture("listZoneRecords/success.http"))

    @subject.list_zone_records(@account_id, @zone_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/records?page=2")
  end

  def test_list_zone_records_supports_extra_request_options
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records})
        .to_return(read_http_fixture("listZoneRecords/success.http"))

    @subject.list_zone_records(@account_id, @zone_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/records?foo=bar")
  end

  def test_list_zone_records_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records})
        .to_return(read_http_fixture("listZoneRecords/success.http"))

    @subject.list_zone_records(@account_id, @zone_id, sort: "type:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/records?sort=type:asc")
  end

  def test_list_zone_records_supports_filtering
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records})
        .to_return(read_http_fixture("listZoneRecords/success.http"))

    @subject.list_zone_records(@account_id, @zone_id, filter: { type: "A" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/records?type=A")
  end

  def test_list_zone_records_returns_the_records
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records})
        .to_return(read_http_fixture("listZoneRecords/success.http"))

    response = @subject.list_zone_records(@account_id, @zone_id)

    assert_kind_of(Dnsimple::PaginatedResponse, response)
    assert_kind_of(Array, response.data)
    assert_equal(5, response.data.size)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::ZoneRecord, result)
      assert_kind_of(Integer, result.id)
      assert_kind_of(Array, result.regions)
    end
  end

  def test_list_zone_records_exposes_pagination_information
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records})
        .to_return(read_http_fixture("listZoneRecords/success.http"))

    response = @subject.list_zone_records(@account_id, @zone_id)

    assert_respond_to(response, :page)
    assert_equal(1, response.page)
    assert_kind_of(Integer, response.per_page)
    assert_kind_of(Integer, response.total_entries)
    assert_kind_of(Integer, response.total_pages)
  end

  def test_list_zone_records_when_zone_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-zone.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.list_zone_records(@account_id, @zone_id)
    end
  end

  def test_all_zone_records_delegates_to_paginate
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records})
        .to_return(read_http_fixture("listZoneRecords/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:list_zone_records, @account_id, @zone_id, { foo: "bar" }])
    @subject.stub(:paginate, mock) do
      @subject.all_zone_records(@account_id, @zone_id, { foo: "bar" })
    end
    mock.verify
  end

  def test_all_zone_records_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records})
        .to_return(read_http_fixture("listZoneRecords/success.http"))

    @subject.all_zone_records(@account_id, @zone_id, sort: "type:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/records?page=1&per_page=100&sort=type:asc")
  end

  def test_all_zone_records_supports_filtering
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records})
        .to_return(read_http_fixture("listZoneRecords/success.http"))

    @subject.all_zone_records(@account_id, @zone_id, filter: { name: "foo", type: "AAAA" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/records?page=1&per_page=100&name=foo&type=AAAA")
  end

  def test_create_zone_record_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/zones/#{@zone_id}/records$})
        .to_return(read_http_fixture("createZoneRecord/created.http"))

    attributes = { type: "A", name: "www", content: "127.0.0.1", regions: %w[global] }
    @subject.create_zone_record(@account_id, @zone_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/records",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_create_zone_record_returns_the_record
    stub_request(:post, %r{/v2/#{@account_id}/zones/#{@zone_id}/records$})
        .to_return(read_http_fixture("createZoneRecord/created.http"))

    attributes = { type: "A", name: "www", content: "127.0.0.1", regions: %w[global] }
    response = @subject.create_zone_record(@account_id, @zone_id, attributes)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::ZoneRecord, result)
    assert_equal(1, result.id)
    assert_equal(attributes.fetch(:type), result.type)
    assert_equal(attributes.fetch(:name), result.name)
    assert_equal(attributes.fetch(:content), result.content)
    assert_equal(attributes.fetch(:regions), result.regions)
  end

  def test_create_zone_record_when_zone_not_found_raises_not_found_error
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-zone.http"))

    attributes = { type: "A", name: "www", content: "127.0.0.1", regions: %w[global] }
    assert_raises(Dnsimple::NotFoundError) do
      @subject.create_zone_record(@account_id, @zone_id, attributes)
    end
  end

  def test_zone_record_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records/.+$})
        .to_return(read_http_fixture("getZoneRecord/success.http"))

    record_id = 5
    @subject.zone_record(@account_id, @zone_id, record_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/records/#{record_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_zone_record_returns_the_record
    stub_request(:get, %r{/v2/#{@account_id}/zones/#{@zone_id}/records/.+$})
        .to_return(read_http_fixture("getZoneRecord/success.http"))

    record_id = 5
    response = @subject.zone_record(@account_id, @zone_id, record_id)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::ZoneRecord, result)
    assert_equal(record_id, result.id)
    assert_equal("example.com", result.zone_id)
    assert_nil(result.parent_id)
    assert_equal("MX", result.type)
    assert_equal("", result.name)
    assert_equal("mxa.example.com", result.content)
    assert_equal(600, result.ttl)
    assert_equal(10, result.priority)
    assert_equal(false, result.system_record)
    assert_equal(%w[SV1 IAD], result.regions)
    assert_equal("2016-10-05T09:51:35Z", result.created_at)
    assert_equal("2016-10-05T09:51:35Z", result.updated_at)
  end

  def test_zone_record_when_zone_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-zone.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.zone_record(@account_id, @zone_id, "0")
    end
  end

  def test_zone_record_when_record_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-record.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.zone_record(@account_id, @zone_id, "0")
    end
  end

  def test_update_zone_record_builds_correct_request
    stub_request(:patch, %r{/v2/#{@account_id}/zones/#{@zone_id}/records/.+$})
        .to_return(read_http_fixture("updateZoneRecord/success.http"))

    attributes = { content: "mxb.example.com", priority: "20", regions: ["global"] }
    record_id = 5
    @subject.update_zone_record(@account_id, @zone_id, record_id, attributes)

    assert_requested(:patch, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/records/#{record_id}",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_update_zone_record_returns_the_record
    stub_request(:patch, %r{/v2/#{@account_id}/zones/#{@zone_id}/records/.+$})
        .to_return(read_http_fixture("updateZoneRecord/success.http"))

    attributes = { content: "mxb.example.com", priority: "20", regions: ["global"] }
    record_id = 5
    response = @subject.update_zone_record(@account_id, @zone_id, record_id, attributes)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::ZoneRecord, result)
    assert_equal(record_id, result.id)
    assert_equal(attributes.fetch(:content), result.content)
    assert_equal(attributes.fetch(:priority).to_i, result.priority)
    assert_equal(attributes.fetch(:regions), result.regions)
  end

  def test_update_zone_record_when_zone_not_found_raises_not_found_error
    stub_request(:patch, %r{/v2})
        .to_return(read_http_fixture("notfound-zone.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.update_zone_record(@account_id, @zone_id, "0", {})
    end
  end

  def test_update_zone_record_when_record_not_found_raises_not_found_error
    stub_request(:patch, %r{/v2})
        .to_return(read_http_fixture("notfound-record.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.update_zone_record(@account_id, @zone_id, "0", {})
    end
  end

  def test_delete_zone_record_builds_correct_request
    stub_request(:delete, %r{/v2/#{@account_id}/zones/#{@zone_id}/records/.+$})
        .to_return(read_http_fixture("deleteZoneRecord/success.http"))

    record_id = 2
    @subject.delete_zone_record(@account_id, @zone_id, record_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/records/#{record_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_delete_zone_record_returns_nothing
    stub_request(:delete, %r{/v2/#{@account_id}/zones/#{@zone_id}/records/.+$})
        .to_return(read_http_fixture("deleteZoneRecord/success.http"))

    response = @subject.delete_zone_record(@account_id, @zone_id, 2)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_nil(result)
  end

  def test_delete_zone_record_when_zone_not_found_raises_not_found_error
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-zone.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.delete_zone_record(@account_id, @zone_id, "0")
    end
  end

  def test_delete_zone_record_when_record_not_found_raises_not_found_error
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-record.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.delete_zone_record(@account_id, @zone_id, "0")
    end
  end

  def test_batch_change_zone_records_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/zones/#{@zone_id}/batch$})
        .to_return(read_http_fixture("batchChangeZoneRecords/success.http"))

    attributes = { creates: [{ type: "A", content: "3.2.3.4", name: "ab" }, { type: "A", content: "4.2.3.4", name: "ab" }], updates: [{ id: 67622534, content: "3.2.3.40", name: "update1-1757049890" }, { id: 67622537, content: "5.2.3.40", name: "update2-1757049890" }], deletes: [{ id: 67622509 }, { id: 67622527 }] }
    @subject.batch_change_zone_records(@account_id, @zone_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/zones/#{@zone_id}/batch",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_batch_change_zone_records_returns_the_result
    stub_request(:post, %r{/v2/#{@account_id}/zones/#{@zone_id}/batch$})
        .to_return(read_http_fixture("batchChangeZoneRecords/success.http"))

    attributes = { creates: [{ type: "A", content: "3.2.3.4", name: "ab" }, { type: "A", content: "4.2.3.4", name: "ab" }], updates: [{ id: 67622534, content: "3.2.3.40", name: "update1-1757049890" }, { id: 67622537, content: "5.2.3.40", name: "update2-1757049890" }], deletes: [{ id: 67622509 }, { id: 67622527 }] }
    response = @subject.batch_change_zone_records(@account_id, @zone_id, attributes)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::ZoneRecordsBatchChange, result)
    assert_equal(67623409, result.creates[0].id)
    assert_equal(attributes.fetch(:creates)[0].fetch(:type), result.creates[0].type)
    assert_equal(attributes.fetch(:creates)[0].fetch(:name), result.creates[0].name)
    assert_equal(attributes.fetch(:creates)[0].fetch(:content), result.creates[0].content)
    assert_equal(["global"], result.creates[0].regions)
    assert_equal(67623410, result.creates[1].id)
    assert_equal(67622534, result.updates[0].id)
    assert_equal("A", result.updates[0].type)
    assert_equal(attributes.fetch(:updates)[0].fetch(:name), result.updates[0].name)
    assert_equal(attributes.fetch(:updates)[0].fetch(:content), result.updates[0].content)
    assert_equal(67622537, result.updates[1].id)
    assert_equal(67622509, result.deletes[0].id)
    assert_equal(67622527, result.deletes[1].id)
  end

  def test_batch_change_zone_records_with_create_errors_raises_request_error
    stub_request(:post, %r{/v2/#{@account_id}/zones/#{@zone_id}/batch$})
        .to_return(read_http_fixture("batchChangeZoneRecords/error_400_create_validation_failed.http"))

    attributes = { creates: [{ type: "A", content: "3.2.3.4", name: "ab" }], updates: [], deletes: [] }
    error = assert_raises(Dnsimple::RequestError) do
      @subject.batch_change_zone_records(@account_id, @zone_id, attributes)
    end
    assert_equal("Validation failed", error.message)
    assert_equal("Validation failed", error.attribute_errors["creates"][0]["message"])
    assert_equal(0, error.attribute_errors["creates"][0]["index"])
    assert_equal({ "record_type" => ["unsupported"] }, error.attribute_errors["creates"][0]["errors"])
  end

  def test_batch_change_zone_records_with_update_errors_raises_request_error
    stub_request(:post, %r{/v2/#{@account_id}/zones/#{@zone_id}/batch$})
        .to_return(read_http_fixture("batchChangeZoneRecords/error_400_update_validation_failed.http"))

    attributes = { creates: [], updates: [{ id: 99999999, content: "3.2.3.40", name: "update1" }], deletes: [] }
    error = assert_raises(Dnsimple::RequestError) do
      @subject.batch_change_zone_records(@account_id, @zone_id, attributes)
    end
    assert_equal("Validation failed", error.message)
    assert_equal("Record not found ID=99999999", error.attribute_errors["updates"][0]["message"])
    assert_equal(0, error.attribute_errors["updates"][0]["index"])
  end

  def test_batch_change_zone_records_with_delete_errors_raises_request_error
    stub_request(:post, %r{/v2/#{@account_id}/zones/#{@zone_id}/batch$})
        .to_return(read_http_fixture("batchChangeZoneRecords/error_400_delete_validation_failed.http"))

    attributes = { creates: [], updates: [], deletes: [{ id: 67622509 }] }
    error = assert_raises(Dnsimple::RequestError) do
      @subject.batch_change_zone_records(@account_id, @zone_id, attributes)
    end
    assert_equal("Validation failed", error.message)
    assert_equal("Record not found ID=67622509", error.attribute_errors["deletes"][0]["message"])
    assert_equal(0, error.attribute_errors["deletes"][0]["index"])
  end

  def test_batch_change_zone_records_when_zone_not_found_raises_not_found_error
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-zone.http"))

    attributes = { creates: [], updates: [], deletes: [] }
    assert_raises(Dnsimple::NotFoundError) do
      @subject.batch_change_zone_records(@account_id, @zone_id, attributes)
    end
  end

end
