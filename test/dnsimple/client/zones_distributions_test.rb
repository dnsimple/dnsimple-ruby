# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".zones" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").zones }

  describe "#zone_distribution" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/zones/.+$})
          .to_return(read_http_fixture("checkZoneDistribution/success.http"))
    end

    it "builds the correct request" do
      subject.zone_distribution(account_id, zone = "example.com")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone}/distribution",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the zone distribution check with true when the zone is fully distributed" do
      response = subject.zone_distribution(account_id, "example.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::ZoneDistribution)
      _(result.distributed).must_equal(true)
    end

    it "returns the zone distribution check with false when the zone isn't fully distributed" do
      stub_request(:get, %r{/v2/#{account_id}/zones/.+$})
          .to_return(read_http_fixture("checkZoneDistribution/failure.http"))

      response = subject.zone_distribution(account_id, "example.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::ZoneDistribution)
      _(result.distributed).must_equal(false)
    end

    it "raises an error when the server wasn't able to complete the check" do
      stub_request(:get, %r{/v2/#{account_id}/zones/.+$})
          .to_return(read_http_fixture("checkZoneDistribution/error.http"))

      error = _ {
        subject.zone_distribution(account_id, "example.com")
      }.must_raise(Dnsimple::RequestError)
      _(error.message).must_equal("Could not query zone, connection timed out")
    end

    describe "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        _ {
          subject.zone_distribution(account_id, "example.com")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end


  describe "#zone_record_distribution" do
    let(:account_id) { 1010 }
    let(:zone_id) { "example.com" }
    let(:record_id) { 5 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}/distribution$})
          .to_return(read_http_fixture("checkZoneRecordDistribution/success.http"))
    end

    it "builds the correct request" do
      subject.zone_record_distribution(account_id, zone_id, record_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}/distribution",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the zone record distribution check with true when the zone is fully distributed" do
      response = subject.zone_record_distribution(account_id, zone_id, record_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::ZoneDistribution)
      _(result.distributed).must_equal(true)
    end

    it "returns the zone distribution check with false when the zone isn't fully distributed" do
      stub_request(:get, %r{/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}/distribution$})
          .to_return(read_http_fixture("checkZoneRecordDistribution/failure.http"))

      response = subject.zone_record_distribution(account_id, zone_id, record_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::ZoneDistribution)
      _(result.distributed).must_equal(false)
    end

    it "raises an error when the server wasn't able to complete the check" do
      stub_request(:get, %r{/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}/distribution$})
          .to_return(read_http_fixture("checkZoneRecordDistribution/error.http"))

      error = _ {
        subject.zone_record_distribution(account_id, zone_id, record_id)
      }.must_raise(Dnsimple::RequestError)
      _(error.message).must_equal("Could not query zone, connection timed out")
    end

    describe "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        _ {
          subject.zone_record_distribution(account_id, zone_id, "0")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end

    describe "when the record does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-record.http"))

        _ {
          subject.zone_record_distribution(account_id, zone_id, "0")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

end
