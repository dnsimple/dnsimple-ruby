# frozen_string_literal: true

require "test_helper"

class DomainsDelegationSignerRecordsTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains
    @account_id = 1010
    @domain_id = "example.com"
  end

  def test_delegation_signer_records_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    @subject.delegation_signer_records(@account_id, @domain_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records",
                     headers: { "Accept" => "application/json" })
  end

  def test_delegation_signer_records_supports_pagination
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    @subject.delegation_signer_records(@account_id, @domain_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records?page=2")
  end

  def test_delegation_signer_records_supports_extra_request_options
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    @subject.delegation_signer_records(@account_id, @domain_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records?foo=bar")
  end

  def test_delegation_signer_records_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    @subject.delegation_signer_records(@account_id, @domain_id, sort: "id:asc,from:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records?sort=id:asc,from:desc")
  end

  def test_delegation_signer_records_returns_the_records
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    response = @subject.delegation_signer_records(@account_id, @domain_id)

    assert_kind_of(Dnsimple::PaginatedResponse, response)
    assert_kind_of(Array, response.data)
    assert_equal(1, response.data.size)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::DelegationSignerRecord, result)
      assert_kind_of(Integer, result.id)
    end
  end

  def test_delegation_signer_records_exposes_pagination_information
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    response = @subject.delegation_signer_records(@account_id, @domain_id)

    assert_respond_to(response, :page)
    assert_equal(1, response.page)
    assert_kind_of(Integer, response.per_page)
    assert_kind_of(Integer, response.total_entries)
    assert_kind_of(Integer, response.total_pages)
  end

  def test_delegation_signer_records_when_domain_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.delegation_signer_records(@account_id, @domain_id)
    end
  end

  def test_all_delegation_signer_records_delegates_to_paginate
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:delegation_signer_records, @account_id, @domain_id, { foo: "bar" }])
    @subject.stub(:paginate, mock) do
      @subject.all_delegation_signer_records(@account_id, @domain_id, { foo: "bar" })
    end
    mock.verify
  end

  def test_all_delegation_signer_records_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    @subject.all_delegation_signer_records(@account_id, @domain_id, sort: "id:asc,from:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records?page=1&per_page=100&sort=id:asc,from:desc")
  end

  def test_create_delegation_signer_record_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records$})
        .to_return(read_http_fixture("createDelegationSignerRecord/created.http"))

    attributes = { algorithm: "13", digest: "ABC123", digest_type: "2", keytag: "1111" }
    @subject.create_delegation_signer_record(@account_id, @domain_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_create_delegation_signer_record_returns_the_record
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records$})
        .to_return(read_http_fixture("createDelegationSignerRecord/created.http"))

    attributes = { algorithm: "13", digest: "ABC123", digest_type: "2", keytag: "1111" }
    response = @subject.create_delegation_signer_record(@account_id, @domain_id, attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DelegationSignerRecord, result)
    assert_kind_of(Integer, result.id)
  end

  def test_delegation_signer_record_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records.+$})
        .to_return(read_http_fixture("getDelegationSignerRecord/success.http"))

    ds_record_id = 24
    @subject.delegation_signer_record(@account_id, @domain_id, ds_record_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records/#{ds_record_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_delegation_signer_record_returns_the_record
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records.+$})
        .to_return(read_http_fixture("getDelegationSignerRecord/success.http"))

    ds_record_id = 24
    response = @subject.delegation_signer_record(@account_id, @domain_id, ds_record_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DelegationSignerRecord, result)
    assert_equal(24, result.id)
    assert_equal(1010, result.domain_id)
    assert_equal("8", result.algorithm)
    assert_equal("C1F6E04A5A61FBF65BF9DC8294C363CF11C89E802D926BDAB79C55D27BEFA94F", result.digest)
    assert_equal("2", result.digest_type)
    assert_equal("44620", result.keytag)
    assert_nil(result.public_key)
    assert_equal("2017-03-03T13:49:58Z", result.created_at)
    assert_equal("2017-03-03T13:49:58Z", result.updated_at)
  end

  def test_delegation_signer_record_when_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-delegationSignerRecord.http"))

    ds_record_id = 24
    assert_raises(Dnsimple::NotFoundError) do
      @subject.delegation_signer_record(@account_id, @domain_id, ds_record_id)
    end
  end

  def test_delete_delegation_signer_record_builds_correct_request
    stub_request(:delete, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records/1$})
        .to_return(read_http_fixture("deleteDelegationSignerRecord/success.http"))

    ds_record_id = 1
    @subject.delete_delegation_signer_record(@account_id, @domain_id, ds_record_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records/#{ds_record_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_delete_delegation_signer_record_returns_nothing
    stub_request(:delete, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records/1$})
        .to_return(read_http_fixture("deleteDelegationSignerRecord/success.http"))

    ds_record_id = 1
    response = @subject.delete_delegation_signer_record(@account_id, @domain_id, ds_record_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end

  def test_delete_delegation_signer_record_when_not_found_raises_not_found_error
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-delegationSignerRecord.http"))

    ds_record_id = 1
    assert_raises(Dnsimple::NotFoundError) do
      @subject.delete_delegation_signer_record(@account_id, @domain_id, ds_record_id)
    end
  end
end
