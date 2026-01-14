# frozen_string_literal: true

require "test_helper"

require "bigdecimal/util"

describe Dnsimple::Client, ".billing" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").billing }

  describe "#charges" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/billing/charges})
          .to_return(read_http_fixture("listCharges/success.http"))
    end

    it "builds the correct request" do
      subject.charges(account_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/billing/charges",
                       headers: { "Accept" => "application/json" })
    end

    it "exposes the pagination information" do
      response = subject.charges(account_id)

      _(response).must_respond_to(:page)
      _(response.page).must_equal(1)
      _(response.per_page).must_be_kind_of(Integer)
      _(response.total_entries).must_be_kind_of(Integer)
      _(response.total_pages).must_be_kind_of(Integer)
    end

    it "returns the charges" do
      response = subject.charges(account_id)

      _(response).must_be_kind_of(Dnsimple::PaginatedResponse)
      _(response.data).must_be_kind_of(Array)
      _(response.data.size).must_equal(3)

      response.data.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::Charge)
        _(result.balance_amount).must_be_kind_of(BigDecimal)
        _(result.reference).must_be_kind_of(String)
        _(result.items).must_be_kind_of(Array)
        _(result.items[0]).must_be_kind_of(Dnsimple::Struct::Charge::ChargeItem)
      end

      _(response.data[0].total_amount).must_be_kind_of(BigDecimal)
      _(response.data[0].total_amount.to_s("F")).must_equal("14.5")
      _(response.data[0].items[0].amount).must_be_kind_of(BigDecimal)
      _(response.data[0].items[0].amount.to_s("F")).must_equal("14.5")
    end

    it "supports filters" do
      subject.charges(account_id, filter: { start_date: "2023-01-01", end_date: "2023-08-31" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/billing/charges?start_date=2023-01-01&end_date=2023-08-31")
    end

    it "supports pagination" do
      subject.charges(account_id, page: 2)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/billing/charges?page=2")
    end

    it "supports sorting" do
      subject.charges(account_id, sort: "invoiced:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/billing/charges?sort=invoiced:asc")
    end

    describe "when using a bad filter" do
      before do
        stub_request(:get, %r{/v2/#{account_id}/billing/charges})
            .to_return(read_http_fixture("listCharges/fail-400-bad-filter.http"))
      end

      it "raises error" do
        error = _ {
          subject.charges(account_id, filter: { start_date: "01-01-2023" })
        }.must_raise(Dnsimple::RequestError)
        _(error.message).must_equal("Invalid date format must be ISO8601 (YYYY-MM-DD)")
      end
    end

    describe "when account is not authorized" do
      before do
        stub_request(:get, %r{/v2/#{account_id}/billing/charges})
            .to_return(read_http_fixture("listCharges/fail-403.http"))
      end

      it "raises error" do
        error = _ {
          subject.charges(account_id)
        }.must_raise(Dnsimple::RequestError)
        _(error.message).must_equal("Permission Denied. Required Scope: billing:*:read")
      end
    end
  end
end
