# frozen_string_literal: true

require "test_helper"

class TemplatesRecordsTest < Minitest::Test

  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").templates
    @account_id = 1010
    @template_id = "alpha"
  end

  def test_list_records_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/templates/#{@template_id}/records})
        .to_return(read_http_fixture("listTemplateRecords/success.http"))

    @subject.records(@account_id, @template_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/templates/#{@template_id}/records",
                     headers: { "Accept" => "application/json" })
  end

  def test_list_records_supports_pagination
    stub_request(:get, %r{/v2/#{@account_id}/templates/#{@template_id}/records})
        .to_return(read_http_fixture("listTemplateRecords/success.http"))

    @subject.records(@account_id, @template_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/templates/#{@template_id}/records?page=2")
  end

  def test_list_records_supports_extra_request_options
    stub_request(:get, %r{/v2/#{@account_id}/templates/#{@template_id}/records})
        .to_return(read_http_fixture("listTemplateRecords/success.http"))

    @subject.records(@account_id, @template_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/templates/#{@template_id}/records?foo=bar")
  end

  def test_list_records_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/templates/#{@template_id}/records})
        .to_return(read_http_fixture("listTemplateRecords/success.http"))

    @subject.records(@account_id, @template_id, sort: "type:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/templates/#{@template_id}/records?sort=type:asc")
  end

  def test_list_records_returns_the_list_of_template_records
    stub_request(:get, %r{/v2/#{@account_id}/templates/#{@template_id}/records})
        .to_return(read_http_fixture("listTemplateRecords/success.http"))

    response = @subject.records(@account_id, @template_id)
    assert_kind_of(Dnsimple::PaginatedResponse, response)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::TemplateRecord, result)
      assert_kind_of(Integer, result.id)
      assert_kind_of(String, result.type)
      assert_kind_of(String, result.name)
      assert_kind_of(String, result.content)
    end
  end

  def test_all_records_delegates_to_paginate
    stub_request(:get, %r{/v2/#{@account_id}/templates/#{@template_id}/records})
        .to_return(read_http_fixture("listTemplateRecords/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:records, @account_id, @template_id, { option: "value" }])
    @subject.stub(:paginate, mock) do
      @subject.all_records(@account_id, @template_id, option: "value")
    end
    mock.verify
  end

  def test_all_records_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/templates/#{@template_id}/records})
        .to_return(read_http_fixture("listTemplateRecords/success.http"))

    @subject.all_records(@account_id, @template_id, sort: "type:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/templates/#{@template_id}/records?page=1&per_page=100&sort=type:asc")
  end

  def test_create_record_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/templates/#{@template_id}/records$})
        .to_return(read_http_fixture("createTemplateRecord/created.http"))

    attributes = { type: "MX", name: "", content: "mx.example.com", priority: 10, ttl: 600 }
    @subject.create_record(@account_id, @template_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/templates/#{@template_id}/records",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_create_record_returns_the_record
    stub_request(:post, %r{/v2/#{@account_id}/templates/#{@template_id}/records$})
        .to_return(read_http_fixture("createTemplateRecord/created.http"))

    attributes = { type: "MX", name: "", content: "mx.example.com", priority: 10, ttl: 600 }
    response = @subject.create_record(@account_id, @template_id, attributes)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::TemplateRecord, result)
    assert_equal(300, result.id)
    assert_equal(268, result.template_id)
    assert_equal("", result.name)
    assert_equal("MX", result.type)
    assert_equal("mx.example.com", result.content)
    assert_equal(600, result.ttl)
    assert_equal(10, result.priority)
    assert_equal("2016-05-03T07:51:33Z", result.created_at)
    assert_equal("2016-05-03T07:51:33Z", result.updated_at)
  end

  def test_create_record_raises_error_when_type_is_missing
    stub_request(:post, %r{/v2/#{@account_id}/templates/#{@template_id}/records$})
        .to_return(read_http_fixture("createTemplateRecord/created.http"))

    assert_raises(ArgumentError) do
      @subject.create_record(@account_id, @template_id, name: "", content: "192.168.1.1")
    end
  end

  def test_create_record_raises_error_when_name_is_missing
    stub_request(:post, %r{/v2/#{@account_id}/templates/#{@template_id}/records$})
        .to_return(read_http_fixture("createTemplateRecord/created.http"))

    assert_raises(ArgumentError) do
      @subject.create_record(@account_id, @template_id, type: "A", content: "192.168.1.1")
    end
  end

  def test_create_record_raises_error_when_content_is_missing
    stub_request(:post, %r{/v2/#{@account_id}/templates/#{@template_id}/records$})
        .to_return(read_http_fixture("createTemplateRecord/created.http"))

    assert_raises(ArgumentError) do
      @subject.create_record(@account_id, @template_id, type: "A", name: "")
    end
  end

  def test_create_record_when_template_not_found_raises_not_found_error
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-template.http"))

    attributes = { type: "MX", name: "", content: "mx.example.com", priority: 10, ttl: 600 }
    assert_raises(Dnsimple::NotFoundError) do
      @subject.create_record(@account_id, @template_id, attributes)
    end
  end

  def test_record_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/templates/alpha.com/records/.+$})
        .to_return(read_http_fixture("getTemplateRecord/success.http"))

    template_id = "alpha.com"
    record_id = 301
    @subject.record(@account_id, template_id, record_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/templates/#{template_id}/records/#{record_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_record_returns_the_record
    stub_request(:get, %r{/v2/#{@account_id}/templates/alpha.com/records/.+$})
        .to_return(read_http_fixture("getTemplateRecord/success.http"))

    template_id = "alpha.com"
    response = @subject.record(@account_id, template_id, 301)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::TemplateRecord, result)
    assert_equal(301, result.id)
    assert_equal(268, result.template_id)
    assert_equal("MX", result.type)
    assert_equal("", result.name)
    assert_equal("mx.example.com", result.content)
    assert_equal(600, result.ttl)
    assert_equal(10, result.priority)
    assert_equal("2016-05-03T08:03:26Z", result.created_at)
    assert_equal("2016-05-03T08:03:26Z", result.updated_at)
  end

  def test_delete_record_builds_correct_request
    stub_request(:delete, %r{/v2/#{@account_id}/templates/example.com/records/.+$})
        .to_return(read_http_fixture("deleteTemplateRecord/success.http"))

    template_id = "example.com"
    record_id = 301
    @subject.delete_record(@account_id, template_id, record_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/templates/#{template_id}/records/#{record_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_delete_record_returns_nothing
    stub_request(:delete, %r{/v2/#{@account_id}/templates/example.com/records/.+$})
        .to_return(read_http_fixture("deleteTemplateRecord/success.http"))

    template_id = "example.com"
    response = @subject.delete_record(@account_id, template_id, 301)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_nil(result)
  end

  def test_delete_record_when_template_not_found_raises_not_found_error
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-template.http"))

    template_id = "example.com"
    assert_raises(Dnsimple::NotFoundError) do
      @subject.delete_record(@account_id, template_id, 0)
    end
  end

  def test_delete_record_when_record_not_found_raises_not_found_error
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-record.http"))

    template_id = "example.com"
    assert_raises(Dnsimple::NotFoundError) do
      @subject.delete_record(@account_id, template_id, 0)
    end
  end

end
