require 'spec_helper'

describe Dnsimple::Client, ".zones" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").zones }

  describe "#zone_distribution" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/zones/.+$})
          .to_return(read_http_fixture("checkZoneDistribution/success.http"))
    end

    it "builds the correct request" do
      subject.zone_distribution(account_id, zone = "example.com")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone}/distribution")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the zone distribution check with true when the zone is fully distributed" do
      response = subject.zone_distribution(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::ZoneDistribution)
      expect(result.distributed).to be(true)
    end

    it "returns the zone distribution check with false when the zone isn't fully distributed" do
      stub_request(:get, %r{/v2/#{account_id}/zones/.+$})
          .to_return(read_http_fixture("checkZoneDistribution/failure.http"))

      response = subject.zone_distribution(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::ZoneDistribution)
      expect(result.distributed).to be(false)
    end

    it "raises an error when the server wasn't able to complete the check" do
      stub_request(:get, %r{/v2/#{account_id}/zones/.+$})
          .to_return(read_http_fixture("checkZoneDistribution/error.http"))

      expect {
        subject.zone_distribution(account_id, "example.com")
      }.to raise_error(Dnsimple::RequestError, "Could not query zone, connection timed out")
    end

    context "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        expect {
          subject.zone_distribution(account_id, "example.com")
        }.to raise_error(Dnsimple::NotFoundError)
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

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}/distribution")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the zone record distribution check with true when the zone is fully distributed" do
      response = subject.zone_record_distribution(account_id, zone_id, record_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::ZoneRecordDistribution)
      expect(result.distributed).to be(true)
    end

    it "returns the zone distribution check with false when the zone isn't fully distributed" do
      stub_request(:get, %r{/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}/distribution$})
          .to_return(read_http_fixture("checkZoneRecordDistribution/failure.http"))

      response = subject.zone_record_distribution(account_id, zone_id, record_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::ZoneRecordDistribution)
      expect(result.distributed).to be(false)
    end

    it "raises an error when the server wasn't able to complete the check" do
      stub_request(:get, %r{/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}/distribution$})
          .to_return(read_http_fixture("checkZoneRecordDistribution/error.http"))

      expect {
        subject.zone_record_distribution(account_id, zone_id, record_id)
      }.to raise_error(Dnsimple::RequestError, "Could not query zone, connection timed out")
    end

    context "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        expect {
          subject.zone_record_distribution(account_id, zone_id, "0")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end

    context "when the record does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-record.http"))

        expect {
          subject.zone_record_distribution(account_id, zone_id, "0")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
