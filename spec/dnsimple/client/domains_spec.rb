require 'spec_helper'

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }


  describe "#domains" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains}).
          to_return(read_http_fixture("listDomains/success.http"))
    end

    it "builds the correct request" do
      subject.domains(account_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains").
          with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.domains(account_id, query: { page: 2 })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?page=2")
    end

    it "supports extra request options" do
      subject.domains(account_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?foo=bar")
    end

    it "supports sorting" do
      subject.domains(account_id, sort: "expires_on:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?sort=expires_on:asc")
    end

    it "returns the domains" do
      response = subject.domains(account_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Domain)
        expect(result.id).to be_a(Fixnum)
      end
    end

    it "exposes the pagination information" do
      response = subject.domains(account_id)

      expect(response.respond_to?(:page)).to be_truthy
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Fixnum)
      expect(response.total_entries).to be_a(Fixnum)
      expect(response.total_pages).to be_a(Fixnum)
    end
  end

  describe "#all_domains" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/domains}).
          to_return(read_http_fixture("listDomains/success.http"))
    end

    let(:account_id) { 1010 }

    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:domains, account_id, foo: "bar")
      subject.all_domains(account_id, foo: "bar")
    end

    it "supports sorting" do
      subject.all_domains(account_id, sort: "expires_on:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?page=1&per_page=100&sort=expires_on:asc")
    end
  end

  describe "#create_domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains$}).
          to_return(read_http_fixture("createDomain/created.http"))
    end

    let(:attributes) { { name: "example.com" } }

    it "builds the correct request" do
      subject.create_domain(account_id, attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains").
          with(body: attributes).
          with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      response = subject.create_domain(account_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe "#domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/.+$}).
          to_return(read_http_fixture("getDomain/success.http"))
    end

    it "builds the correct request" do
      subject.domain(account_id, domain = "example.com")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain}").
          with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      response = subject.domain(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to eq(1)
      expect(result.account_id).to eq(1010)
      expect(result.registrant_id).to eq(nil)
      expect(result.name).to eq("example-alpha.com")
      expect(result.state).to eq("hosted")
      expect(result.auto_renew).to eq(false)
      expect(result.private_whois).to eq(false)
      expect(result.expires_on).to eq(nil)
      expect(result.created_at).to eq("2014-12-06T15:56:55.573Z")
      expect(result.updated_at).to eq("2015-12-09T00:20:56.056Z")
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2}).
            to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.domain(account_id, "example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/domains/.+$}).
          to_return(read_http_fixture("deleteDomain/success.http"))
    end

    it "builds the correct request" do
      subject.delete_domain(account_id, domain = "example.com")

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain}").
          with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      response = subject.delete_domain(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2}).
            to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.delete_domain(account_id, "example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#reset_domain_token" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/token}).
          to_return(read_http_fixture("resetDomainToken/success.http"))
    end

    it "builds the correct request" do
      subject.reset_domain_token(account_id, domain_id)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/token").
          with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      response = subject.reset_domain_token(account_id, domain_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to be_a(Fixnum)
    end
  end

end
