require 'spec_helper'

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(api_endpoint: "https://api.dnsimple.test", oauth_access_token: "a1b2c3").domains }


  describe "#domains" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r[/v2/1010/domains])
          .to_return(read_fixture("domains/domains/success.http"))
    end

    it "builds the correct request" do
      subject.domains(account_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.domains(account_id, query: { page: 2 })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?page=2")
    end

    it "returns the domains" do
      results = subject.domains(account_id)

      expect(results).to be_a(Array)
      expect(results.size).to eq(2)

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Domain)
        expect(result.id).to be_a(Fixnum)
      end
    end

    it "exposes the pagination information" do
      results = subject.domains(account_id)

      expect(results.respond_to?(:page)).to be_truthy
      expect(results.page).to eq(1)
      expect(results.per_page).to be_a(Fixnum)
      expect(results.total_entries).to be_a(Fixnum)
      expect(results.total_pages).to be_a(Fixnum)
    end
  end

end