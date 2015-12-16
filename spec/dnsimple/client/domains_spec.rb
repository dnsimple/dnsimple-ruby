require 'spec_helper'

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(api_endpoint: "https://api.dnsimple.test", access_token: "a1b2c3").domains }


  describe "#domains" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r[/v2/#{account_id}/domains])
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

  describe "#all_domains" do
    let(:account_id) { 1010 }

    it "delegates to client.paginate" do
      expect(subject.client).to receive(:paginate).with(subject, :domains, account_id, { foo: "bar" })
      subject.all_domains(account_id, { foo: "bar" })
    end
  end

  describe "#domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r[/v2/#{account_id}/domains/.+$])
          .to_return(read_fixture("domains/domain/success.http"))
    end

    it "builds the correct request" do
      subject.domain(account_id, domain = "example.com")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.domain(account_id, "example.com")

      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to eq(1745)
      expect(result.account_id).to eq(24)
      expect(result.registrant_id).to eq(409)
      expect(result.name).to eq("example-1417881397.com")
      expect(result.state).to eq("expired")
      expect(result.auto_renew).to eq(false)
      expect(result.private_whois).to eq(false)
      expect(result.expires_on).to eq("2015-12-06")
      expect(result.created_at).to eq("2014-12-06T15:56:55.573Z")
      expect(result.updated_at).to eq("2015-12-09T00:20:56.056Z")
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v2])
            .to_return(read_fixture("domains/notfound-domain.http"))

        expect {
          subject.domain(account_id, "example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
