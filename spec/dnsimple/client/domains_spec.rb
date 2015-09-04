require 'spec_helper'

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").domains }


  describe "#domains" do
    before do
      stub_request(:get, %r[/v1/domains$]).
          to_return(read_fixture("domains/domains/success.http"))
    end

    it "builds the correct request" do
      subject.domains

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domains" do
      results = subject.domains

      expect(results).to be_a(Array)
      expect(results.size).to eq(2)

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Domain)
        expect(result.id).to be_a(Fixnum)
      end
    end
  end

  describe "#create_domain" do
    before do
      stub_request(:post, %r[/v1/domains$]).
          to_return(read_fixture("domains/create_domain/created.http"))
    end

    let(:attributes) { { name: "example.com" } }

    it "builds the correct request" do
      subject.create_domain(attributes)

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains").
                             with(body: { domain: attributes }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.create_domain(attributes)

      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe "#domain" do
    before do
      stub_request(:get, %r[/v1/domains/.+$]).
          to_return(read_fixture("domains/domain/success.http"))
    end

    it "builds the correct request" do
      subject.domain("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.domain("example.com")

      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to eq(1)
      expect(result.user_id).to eq(21)
      expect(result.registrant_id).to eq(321)
      expect(result.name).to eq("example.com")
      expect(result.state).to eq("registered")
      expect(result.auto_renew).to eq(true)
      expect(result.whois_protected).to eq(false)
      expect(result.expires_on).to eq("2015-09-27")
      expect(result.created_at).to eq("2012-09-27T14:25:57.646Z")
      expect(result.updated_at).to eq("2014-12-15T20:27:04.552Z")
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("domains/notfound-domain.http"))

        expect {
          subject.domain("example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_domain" do
    before do
      stub_request(:delete, %r[/v1/domains/.+$]).
          to_return(read_fixture("domains/delete_domain/success.http"))
    end

    it "builds the correct request" do
      subject.delete_domain("example.com")

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/domains/example.com").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.delete_domain("example.com")

      expect(result).to be_truthy
    end

    it "supports HTTP 204" do
      stub_request(:delete, %r[/v1]).
          to_return(read_fixture("domains/delete_domain/success-204.http"))

      result = subject.delete_domain("example.com")

      expect(result).to be_truthy
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("domains/notfound-domain.http"))

        expect {
          subject.delete_domain("example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
