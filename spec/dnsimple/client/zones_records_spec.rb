# frozen_string_literal: true

require 'spec_helper'

describe Dnsimple::Client, ".zones" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").zones }


  describe "#list_zone_records" do
    let(:account_id) { 1010 }
    let(:zone_id) { "example.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/zones/#{zone_id}/records})
          .to_return(read_http_fixture("listZoneRecords/success.http"))
    end

    it "builds the correct request" do
      subject.list_zone_records(account_id, zone_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.list_zone_records(account_id, zone_id, page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?page=2")
    end

    it "supports extra request options" do
      subject.list_zone_records(account_id, zone_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?foo=bar")
    end

    it "supports sorting" do
      subject.list_zone_records(account_id, zone_id, sort: "type:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?sort=type:asc")
    end

    it "supports filtering" do
      subject.list_zone_records(account_id, zone_id, filter: { type: "A" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?type=A")
    end

    it "returns the records" do
      response = subject.list_zone_records(account_id, zone_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(5)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::ZoneRecord)
        expect(result.id).to be_a(Integer)
        expect(result.regions).to be_a(Array)
      end
    end

    it "exposes the pagination information" do
      response = subject.list_zone_records(account_id, zone_id)

      expect(response.respond_to?(:page)).to be(true)
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Integer)
      expect(response.total_entries).to be_a(Integer)
      expect(response.total_pages).to be_a(Integer)
    end

    context "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        expect {
          subject.list_zone_records(account_id, zone_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#all_zone_records" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/zones/#{zone_id}/records})
          .to_return(read_http_fixture("listZoneRecords/success.http"))
    end

    let(:account_id) { 1010 }
    let(:zone_id) { "example.com" }

    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:list_zone_records, account_id, zone_id, { foo: "bar" })
      subject.all_zone_records(account_id, zone_id, { foo: "bar" })
    end

    it "supports sorting" do
      subject.all_zone_records(account_id, zone_id, sort: "type:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?page=1&per_page=100&sort=type:asc")
    end

    it "supports filtering" do
      subject.all_zone_records(account_id, zone_id, filter: { name: "foo", type: "AAAA" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?page=1&per_page=100&name=foo&type=AAAA")
    end
  end

  describe "#create_zone_record" do
    let(:account_id) { 1010 }
    let(:attributes) { { type: "A", name: "www", content: "127.0.0.1", regions: %w(global) } }
    let(:zone_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/zones/#{zone_id}/records$})
          .to_return(read_http_fixture("createZoneRecord/created.http"))
    end


    it "builds the correct request" do
      subject.create_zone_record(account_id, zone_id, attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      response = subject.create_zone_record(account_id, zone_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::ZoneRecord)
      expect(result.id).to eq(1)
      expect(result.type).to eq(attributes.fetch(:type))
      expect(result.name).to eq(attributes.fetch(:name))
      expect(result.content).to eq(attributes.fetch(:content))
      expect(result.regions).to eq(attributes.fetch(:regions))
    end

    context "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        expect {
          subject.create_zone_record(account_id, zone_id, attributes)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#zone_record" do
    let(:account_id) { 1010 }
    let(:zone_id) { "example.com" }
    let(:record_id) { 5 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/zones/#{zone_id}/records/.+$})
          .to_return(read_http_fixture("getZoneRecord/success.http"))
    end

    it "builds the correct request" do
      subject.zone_record(account_id, zone_id, record_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      response = subject.zone_record(account_id, zone_id, record_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::ZoneRecord)
      expect(result.id).to eq(record_id)
      expect(result.zone_id).to eq("example.com")
      expect(result.parent_id).to eq(nil)
      expect(result.type).to eq("MX")
      expect(result.name).to eq("")
      expect(result.content).to eq("mxa.example.com")
      expect(result.ttl).to eq(600)
      expect(result.priority).to eq(10)
      expect(result.system_record).to be(false)
      expect(result.regions).to eq(%w(SV1 IAD))
      expect(result.created_at).to eq("2016-10-05T09:51:35Z")
      expect(result.updated_at).to eq("2016-10-05T09:51:35Z")
    end

    context "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        expect {
          subject.zone_record(account_id, zone_id, "0")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end

    context "when the record does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-record.http"))

        expect {
          subject.zone_record(account_id, zone_id, "0")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#update_zone_record" do
    let(:account_id) { 1010 }
    let(:attributes) { { content: "mxb.example.com", priority: "20", regions: ['global'] } }
    let(:zone_id) { "example.com" }
    let(:record_id) { 5 }

    before do
      stub_request(:patch, %r{/v2/#{account_id}/zones/#{zone_id}/records/.+$})
          .to_return(read_http_fixture("updateZoneRecord/success.http"))
    end


    it "builds the correct request" do
      subject.update_zone_record(account_id, zone_id, record_id, attributes)

      expect(WebMock).to have_requested(:patch, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      response = subject.update_zone_record(account_id, zone_id, record_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::ZoneRecord)
      expect(result.id).to eq(record_id)
      expect(result.content).to eq(attributes.fetch(:content))
      expect(result.priority).to eq(attributes.fetch(:priority).to_i)
      expect(result.regions).to eq(attributes.fetch(:regions))
    end

    context "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:patch, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        expect {
          subject.update_zone_record(account_id, zone_id, "0", {})
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end

    context "when the record does not exist" do
      it "raises NotFoundError" do
        stub_request(:patch, %r{/v2})
            .to_return(read_http_fixture("notfound-record.http"))

        expect {
          subject.update_zone_record(account_id, zone_id, "0", {})
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_zone_record" do
    let(:account_id) { 1010 }
    let(:zone_id) { "example.com" }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/zones/#{zone_id}/records/.+$})
          .to_return(read_http_fixture("deleteZoneRecord/success.http"))
    end

    it "builds the correct request" do
      subject.delete_zone_record(account_id, zone_id, record_id = 2)

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      response = subject.delete_zone_record(account_id, zone_id, 2)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end

    context "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        expect {
          subject.delete_zone_record(account_id, zone_id, "0")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end

    context "when the record does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-record.http"))

        expect {
          subject.delete_zone_record(account_id, zone_id, "0")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
