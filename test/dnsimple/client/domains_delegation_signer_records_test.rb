# frozen_string_literal: true

require "test_helper"

class DomainsDelegationSignerRecordsTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains
    @account_id = 1010
    @domain_id = "example.com"
  end

  test "delegation signer records builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    @subject.delegation_signer_records(@account_id, @domain_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records",
                     headers: { "Accept" => "application/json" })
  end

  test "delegation signer records supports pagination" do
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    @subject.delegation_signer_records(@account_id, @domain_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records?page=2")
  end

  test "delegation signer records supports extra request options" do
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    @subject.delegation_signer_records(@account_id, @domain_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records?foo=bar")
  end

  test "delegation signer records supports sorting" do
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    @subject.delegation_signer_records(@account_id, @domain_id, sort: "id:asc,from:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records?sort=id:asc,from:desc")
  end

  test "delegation signer records returns the records" do
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

  test "delegation signer records exposes pagination information" do
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    response = @subject.delegation_signer_records(@account_id, @domain_id)

    assert_respond_to(response, :page)
    assert_equal(1, response.page)
    assert_kind_of(Integer, response.per_page)
    assert_kind_of(Integer, response.total_entries)
    assert_kind_of(Integer, response.total_pages)
  end

  test "delegation signer records when domain not found raises not found error" do
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.delegation_signer_records(@account_id, @domain_id)
    end
  end

  test "all delegation signer records delegates to paginate" do
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:delegation_signer_records, @account_id, @domain_id, { foo: "bar" }])
    @subject.stub(:paginate, mock) do
      @subject.all_delegation_signer_records(@account_id, @domain_id, { foo: "bar" })
    end
    mock.verify
  end

  test "all delegation signer records supports sorting" do
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records})
        .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))

    @subject.all_delegation_signer_records(@account_id, @domain_id, sort: "id:asc,from:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records?page=1&per_page=100&sort=id:asc,from:desc")
  end

  test "create delegation signer record builds correct request" do
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records$})
        .to_return(read_http_fixture("createDelegationSignerRecord/created.http"))

    attributes = { algorithm: "13", digest: "ABC123", digest_type: "2", keytag: "1111" }
    @subject.create_delegation_signer_record(@account_id, @domain_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  test "create delegation signer record returns the record" do
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records$})
        .to_return(read_http_fixture("createDelegationSignerRecord/created.http"))

    attributes = { algorithm: "13", digest: "ABC123", digest_type: "2", keytag: "1111" }
    response = @subject.create_delegation_signer_record(@account_id, @domain_id, attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DelegationSignerRecord, result)
    assert_kind_of(Integer, result.id)
  end

  test "delegation signer record builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records.+$})
        .to_return(read_http_fixture("getDelegationSignerRecord/success.http"))

    ds_record_id = 24
    @subject.delegation_signer_record(@account_id, @domain_id, ds_record_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records/#{ds_record_id}",
                     headers: { "Accept" => "application/json" })
  end

  test "delegation signer record returns the record" do
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

  test "delegation signer record when not found raises not found error" do
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-delegationSignerRecord.http"))

    ds_record_id = 24
    assert_raises(Dnsimple::NotFoundError) do
      @subject.delegation_signer_record(@account_id, @domain_id, ds_record_id)
    end
  end

  test "delete delegation signer record builds correct request" do
    stub_request(:delete, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records/1$})
        .to_return(read_http_fixture("deleteDelegationSignerRecord/success.http"))

    ds_record_id = 1
    @subject.delete_delegation_signer_record(@account_id, @domain_id, ds_record_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/ds_records/#{ds_record_id}",
                     headers: { "Accept" => "application/json" })
  end

  test "delete delegation signer record returns nothing" do
    stub_request(:delete, %r{/v2/#{@account_id}/domains/#{@domain_id}/ds_records/1$})
        .to_return(read_http_fixture("deleteDelegationSignerRecord/success.http"))

    ds_record_id = 1
    response = @subject.delete_delegation_signer_record(@account_id, @domain_id, ds_record_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end

  test "delete delegation signer record when not found raises not found error" do
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-delegationSignerRecord.http"))

    ds_record_id = 1
    assert_raises(Dnsimple::NotFoundError) do
      @subject.delete_delegation_signer_record(@account_id, @domain_id, ds_record_id)
    end
  end
end
