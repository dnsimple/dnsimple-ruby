require 'spec_helper'

describe Dnsimple::Client, ".zones" do

  subject { described_class.new(api_endpoint: "https://api.dnsimple.test", access_token: "a1b2c3").zones }


  describe "#records" do
    let(:account_id) { 1010 }
    let(:zone_id) { "example.com" }

    before do
      stub_request(:get, %r[/v2/#{account_id}/zones/#{zone_id}/records])
          .to_return(read_fixture("zones/records/success.http"))
    end

    it "builds the correct request" do
      subject.records(account_id, zone_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.records(account_id, zone_id, query: { page: 2 })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?page=2")
    end

    it "supports extra request options" do
      subject.records(account_id, zone_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?foo=bar")
    end

    it "returns the records" do
      response = subject.records(account_id, zone_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(5)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Record)
        expect(result.id).to be_a(Fixnum)
      end
    end

    it "exposes the pagination information" do
      response = subject.records(account_id, zone_id)

      expect(response.respond_to?(:page)).to be_truthy
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Fixnum)
      expect(response.total_entries).to be_a(Fixnum)
      expect(response.total_pages).to be_a(Fixnum)
    end
  end

  describe "#all_records" do
    let(:account_id) { 1010 }
    let(:zone_id) { "example.com" }

    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:records, account_id, zone_id, { foo: "bar" })
      subject.all_records(account_id, zone_id, { foo: "bar" })
    end
  end

end
