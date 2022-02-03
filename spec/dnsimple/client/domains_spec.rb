# frozen_string_literal: true

require 'spec_helper'

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }


  describe "#domains" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains})
          .to_return(read_http_fixture("listDomains/success.http"))
    end

    it "builds the correct request" do
      subject.domains(account_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.domains(account_id, page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?page=2")
    end

    it "supports extra request options" do
      subject.domains(account_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?foo=bar")
    end

    it "supports sorting" do
      subject.domains(account_id, sort: "expiration:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?sort=expiration:asc")
    end

    it "supports filtering" do
      subject.domains(account_id, filter: { name_like: 'example' })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?name_like=example")
    end

    it "returns the domains" do
      response = subject.domains(account_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Domain)
        expect(result.id).to be_a(Integer)
      end
    end

    it "exposes the pagination information" do
      response = subject.domains(account_id)

      expect(response.respond_to?(:page)).to be(true)
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Integer)
      expect(response.total_entries).to be_a(Integer)
      expect(response.total_pages).to be_a(Integer)
    end
  end

  describe "#all_domains" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/domains})
          .to_return(read_http_fixture("listDomains/success.http"))
    end

    let(:account_id) { 1010 }

    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:domains, account_id, { foo: "bar" })
      subject.all_domains(account_id, { foo: "bar" })
    end

    it "supports sorting" do
      subject.all_domains(account_id, sort: "expiration:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?page=1&per_page=100&sort=expiration:asc")
    end

    it "supports filtering" do
      subject.all_domains(account_id, filter: { registrant_id: 99 })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?page=1&per_page=100&registrant_id=99")
    end
  end

  describe "#create_domain" do
    let(:account_id) { 1010 }
    let(:attributes) { { name: "example.com" } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains$})
          .to_return(read_http_fixture("createDomain/created.http"))
    end


    it "builds the correct request" do
      subject.create_domain(account_id, attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      response = subject.create_domain(account_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to be_a(Integer)
    end
  end

  describe "#domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/.+$})
          .to_return(read_http_fixture("getDomain/success.http"))
    end

    it "builds the correct request" do
      subject.domain(account_id, domain = "example-alpha.com")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      response = subject.domain(account_id, "example-alpha.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to eq(181984)
      expect(result.account_id).to eq(1385)
      expect(result.registrant_id).to eq(2715)
      expect(result.name).to eq("example-alpha.com")
      expect(result.state).to eq("registered")
      expect(result.auto_renew).to be(false)
      expect(result.private_whois).to be(false)
      expect(result.expires_at).to eq("2021-06-05T02:15:00Z")
      expect(result.created_at).to eq("2020-06-04T19:15:14Z")
      expect(result.updated_at).to eq("2020-06-04T19:15:21Z")
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.domain(account_id, "example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/domains/.+$})
          .to_return(read_http_fixture("deleteDomain/success.http"))
    end

    it "builds the correct request" do
      subject.delete_domain(account_id, domain = "example.com")

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      response = subject.delete_domain(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.delete_domain(account_id, "example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end
end
