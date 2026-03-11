# frozen_string_literal: true

require "test_helper"

require "bigdecimal/util"

class BillingTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").billing
    @account_id = 1010
  end

  test "builds the correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/billing/charges})
        .to_return(read_http_fixture("listCharges/success.http"))

    @subject.charges(@account_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/billing/charges",
                     headers: { "Accept" => "application/json" })
  end

  test "exposes the pagination information" do
    stub_request(:get, %r{/v2/#{@account_id}/billing/charges})
        .to_return(read_http_fixture("listCharges/success.http"))

    response = @subject.charges(@account_id)

    assert_respond_to(response, :page)
    assert_equal(1, response.page)
    assert_kind_of(Integer, response.per_page)
    assert_kind_of(Integer, response.total_entries)
    assert_kind_of(Integer, response.total_pages)
  end

  test "returns the charges" do
    stub_request(:get, %r{/v2/#{@account_id}/billing/charges})
        .to_return(read_http_fixture("listCharges/success.http"))

    response = @subject.charges(@account_id)

    assert_kind_of(Dnsimple::PaginatedResponse, response)
    assert_kind_of(Array, response.data)
    assert_equal(3, response.data.size)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::Charge, result)
      assert_kind_of(BigDecimal, result.balance_amount)
      assert_kind_of(String, result.reference)
      assert_kind_of(Array, result.items)
      assert_kind_of(Dnsimple::Struct::Charge::ChargeItem, result.items[0])
    end

    assert_kind_of(BigDecimal, response.data[0].total_amount)
    assert_equal("14.5", response.data[0].total_amount.to_s("F"))
    assert_kind_of(BigDecimal, response.data[0].items[0].amount)
    assert_equal("14.5", response.data[0].items[0].amount.to_s("F"))
  end

  test "supports filters" do
    stub_request(:get, %r{/v2/#{@account_id}/billing/charges})
        .to_return(read_http_fixture("listCharges/success.http"))

    @subject.charges(@account_id, filter: { start_date: "2023-01-01", end_date: "2023-08-31" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/billing/charges?start_date=2023-01-01&end_date=2023-08-31")
  end

  test "supports pagination" do
    stub_request(:get, %r{/v2/#{@account_id}/billing/charges})
        .to_return(read_http_fixture("listCharges/success.http"))

    @subject.charges(@account_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/billing/charges?page=2")
  end

  test "supports sorting" do
    stub_request(:get, %r{/v2/#{@account_id}/billing/charges})
        .to_return(read_http_fixture("listCharges/success.http"))

    @subject.charges(@account_id, sort: "invoiced:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/billing/charges?sort=invoiced:asc")
  end

  test "raises error when using a bad filter" do
    stub_request(:get, %r{/v2/#{@account_id}/billing/charges})
        .to_return(read_http_fixture("listCharges/fail-400-bad-filter.http"))

    error = assert_raises(Dnsimple::RequestError) do
      @subject.charges(@account_id, filter: { start_date: "01-01-2023" })
    end
    assert_equal("Invalid date format must be ISO8601 (YYYY-MM-DD)", error.message)
  end

  test "raises error when account is not authorized" do
    stub_request(:get, %r{/v2/#{@account_id}/billing/charges})
        .to_return(read_http_fixture("listCharges/fail-403.http"))

    error = assert_raises(Dnsimple::RequestError) do
      @subject.charges(@account_id)
    end
    assert_equal("Permission Denied. Required Scope: billing:*:read", error.message)
  end
end
