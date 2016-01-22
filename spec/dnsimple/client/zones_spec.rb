require 'spec_helper'

describe Dnsimple::Client, ".zones" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").zones }


  describe "#zones" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r[/v2/#{account_id}/zones])
          .to_return(read_http_fixture("listZones/success.http"))
    end

    it "builds the correct request" do
      subject.zones(account_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.zones(account_id, query: { page: 2 })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones?page=2")
    end

    it "supports extra request options" do
      subject.zones(account_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones?foo=bar")
    end

    it "returns the zones" do
      response = subject.zones(account_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Zone)
        expect(result.id).to be_a(Fixnum)
      end
    end

    it "exposes the pagination information" do
      response = subject.zones(account_id)

      expect(response.respond_to?(:page)).to be_truthy
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Fixnum)
      expect(response.total_entries).to be_a(Fixnum)
      expect(response.total_pages).to be_a(Fixnum)
    end
  end

  describe "#all_zones" do
    let(:account_id) { 1010 }

    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:zones, account_id, { foo: "bar" })
      subject.all_zones(account_id, { foo: "bar" })
    end
  end

end
