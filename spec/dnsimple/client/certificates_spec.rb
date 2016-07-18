require 'spec_helper'

describe Dnsimple::Client, ".certificates" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").certificates }


  describe "#certificates" do
    let(:account_id) { 1010 }
    let(:domain_id)  { "example.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/certificates}).
          to_return(read_http_fixture("listCertificates/success.http"))
    end

    it "builds the correct request" do
      subject.certificates(account_id, domain_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates").
          with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.certificates(account_id, domain_id, page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates?page=2")
    end

    it "supports extra request options" do
      subject.certificates(account_id, domain_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates?foo=bar")
    end

    it "returns the certificates" do
      response = subject.certificates(account_id, domain_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Certificate)
        expect(result.id).to be_a(Fixnum)
      end
    end

    it "exposes the pagination information" do
      response = subject.certificates(account_id, domain_id)

      expect(response.respond_to?(:page)).to be_truthy
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Fixnum)
      expect(response.total_entries).to be_a(Fixnum)
      expect(response.total_pages).to be_a(Fixnum)
    end
  end

end
