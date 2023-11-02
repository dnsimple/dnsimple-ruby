# frozen_string_literal: true

require 'spec_helper'

require 'bigdecimal/util'

describe Dnsimple::Client, ".billing" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").billing }

  describe "#charges" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/billing/charges})
          .to_return(read_http_fixture("listCharges/success.http"))
    end

    it "builds the correct request" do
      subject.charges(account_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/billing/charges")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "exposes the pagination information" do
      response = subject.charges(account_id)

      expect(response.respond_to?(:page)).to be(true)
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Integer)
      expect(response.total_entries).to be_a(Integer)
      expect(response.total_pages).to be_a(Integer)
    end

    it "returns the charges" do
      response = subject.charges(account_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(3)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Charge)
        expect(result.balance_amount).to be_a(BigDecimal)
        expect(result.reference).to be_a(String)
        expect(result.items).to be_a(Array)
        expect(result.items[0]).to be_a(Dnsimple::Struct::Charge::ChargeItem)
      end

      expect(response.data[0].total_amount).to be_a(BigDecimal)
      expect(response.data[0].total_amount.to_s("F")).to eq("14.5")
      expect(response.data[0].items[0].amount).to be_a(BigDecimal)
      expect(response.data[0].items[0].amount.to_s("F")).to eq("14.5")
    end

    it "supports filters" do
      subject.charges(account_id, filter: { start_date: "2023-01-01", end_date: "2023-08-31" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/billing/charges?start_date=2023-01-01&end_date=2023-08-31")
    end

    it "supports pagination" do
      subject.charges(account_id, page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/billing/charges?page=2")
    end

    it "supports sorting" do
      subject.charges(account_id, sort: "invoiced:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/billing/charges?sort=invoiced:asc")
    end

    context "when using a bad filter" do
      before do
        stub_request(:get, %r{/v2/#{account_id}/billing/charges})
            .to_return(read_http_fixture("listCharges/fail-400-bad-filter.http"))
      end

      it "raises error" do
        expect do
          subject.charges(account_id, filter: { start_date: "01-01-2023" })
        end.to raise_error(Dnsimple::RequestError, "Invalid date format must be ISO8601 (YYYY-MM-DD)")
      end
    end

    context "when account is not authorized" do
      before do
        stub_request(:get, %r{/v2/#{account_id}/billing/charges})
            .to_return(read_http_fixture("listCharges/fail-403.http"))
      end

      it "raises error" do
        expect do
          subject.charges(account_id)
        end.to raise_error(Dnsimple::RequestError, "Permission Denied. Required Scope: billing:*:read")
      end
    end
  end
end
