require 'spec_helper'

describe Dnsimple::Client, ".tlds" do
  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").tlds }

  describe "#tlds" do
    before do
      stub_request(:get, %r[/v2/tlds])
          .to_return(read_http_fixture("listTlds/success.http"))
    end

    it "builds the correct request" do
      subject.tlds

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/tlds")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.tlds(query: { page: 2 })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/tlds?page=2")
    end

    it "supports additional options" do
      subject.tlds(query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/tlds?foo=bar")
    end

    it "returns the tlds" do
      response = subject.tlds

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_an(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Tld)
        expect(result.tld_type).to be_a(Fixnum)
        expect(result.tld).to be_a(String)
      end
    end

    it "exposes the pagination information" do
      response = subject.tlds

      expect(response.respond_to?(:page)).to be_truthy
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Fixnum)
      expect(response.total_entries).to be_a(Fixnum)
      expect(response.total_pages).to be_a(Fixnum)
    end
  end

  describe "#all_tlds" do
    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:tlds, { foo: "bar" })
      subject.all_tlds({ foo: "bar" })
    end
  end
end
