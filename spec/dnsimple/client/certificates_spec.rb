require 'spec_helper'

describe Dnsimple::Client, ".certificates" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").certificates }


  describe "#certificates" do
    before do
      stub_request(:get, %r[/v1/domains/.+/certificates$]).
          to_return(read_fixture("certificates/list/success.http"))
    end

    it "builds the correct request" do
      subject.certificates("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/certificates").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the records" do
      results = subject.certificates("example.com")

      expect(results).to be_a(Array)
      expect(results.size).to eq(2)

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Certificate)
        expect(result.id).to be_a(Fixnum)
      end
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("domains/notfound-domain.http"))

        expect {
          subject.certificates("example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#certificate" do
    before do
      stub_request(:get, %r[/v1/domains/.+/certificates/.+$]).
          to_return(read_fixture("certificates/get/success.http"))
    end

    it "builds the correct request" do
      subject.certificate("example.com", 2)

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/certificates/2").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the certificate" do
      result = subject.certificate("example.com", 2)

      expect(result).to be_a(Dnsimple::Struct::Certificate)
      expect(result.id).to eq(4576)
      expect(result.domain_id).to eq(79569)
      expect(result.contact_id).to eq(11549)
      expect(result.name).to eq("www")
      expect(result.state).to eq("cancelled")
      expect(result.csr).to eq("-----BEGIN NEW CERTIFICATE REQUEST-----\nRHr2akB4KMba6FMAsvlStnO/2ika16hNx+d3smPNsER+HA==\n-----END NEW CERTIFICATE REQUEST-----\n")
      expect(result.ssl_certificate).to eq("-----BEGIN CERTIFICATE-----\nXwTkw5UCPpaVyUYcwHlvaprOe9ZbwIyEHm2AT1rW+70=\n-----END CERTIFICATE-----\n")
      expect(result.private_key).to eq("-----BEGIN RSA PRIVATE KEY-----\nUeXbFi7o+nuPfRhpBFQEKwacKFc3Hnc1hH6UsnC0KY25cUif7yz38A==\n-----END RSA PRIVATE KEY-----\n")
      expect(result.approver_email).to eq("example@example.net")
      expect(result.created_at).to eq("2013-09-17T21:54:42Z")
      expect(result.updated_at).to eq("2013-09-17T22:25:36Z")
      expect(result.configured_at).to eq("2013-09-17T22:25:01Z")
      expect(result.expires_on).to eq("2014-09-17")
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("certificates/notfound.http"))

        expect {
          subject.certificate("example.com", 2)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#purchase" do
    before do
      stub_request(:post, %r[/v1/domains/.+/certificates$]).
          to_return(read_fixture("certificates/purchase/success.http"))
    end

    it "builds the correct request" do
      subject.purchase("example.com", "www", 100)

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/example.com/certificates").
                             with(body: { certificate: { name: "www", contact_id: "100" } }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "merges custom options" do
      subject.purchase("example.com", "www", 100, certificate: { csr: "CUSTOM" }, something: "else")

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/example.com/certificates").
                             with(body: { certificate: { name: "www", contact_id: "100", csr: "CUSTOM" }, something: "else"}).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the certificate" do
      result = subject.purchase("example.com", "www", 100)

      expect(result).to be_a(Dnsimple::Struct::Certificate)
      expect(result.id).to be_a(Fixnum)
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("domains/notfound-domain.http"))

        expect {
          subject.purchase("example.com", "www", 100)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#configure" do
    before do
      stub_request(:put, %r[/v1/domains/.+/certificates/.+/configure$]).
          to_return(read_fixture("certificates/configure/success.http"))
    end

    it "builds the correct request" do
      subject.configure("example.com", 2)

      expect(WebMock).to have_requested(:put, "https://api.zone/v1/domains/example.com/certificates/2/configure").
                             with(body: {}).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the certificate" do
      result = subject.configure("example.com", 2)

      expect(result).to be_a(Dnsimple::Struct::Certificate)
      expect(result.id).to be_a(Fixnum)
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:put, %r[/v1]).
            to_return(read_fixture("certificates/notfound.http"))

        expect {
          subject.configure("example.com", 2)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#submit" do
    before do
      stub_request(:put, %r[/v1/domains/.+/certificates/.+/submit]).
          to_return(read_fixture("certificates/submit/success.http"))
    end

    it "builds the correct request" do
      subject.submit("example.com", 2, "admin@example.com")

      expect(WebMock).to have_requested(:put, "https://api.zone/v1/domains/example.com/certificates/2/submit").
                             with(body: { certificate: { approver_email: "admin@example.com" } }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the certificate" do
      result = subject.submit("example.com", 2, "admin@example.com")

      expect(result).to be_a(Dnsimple::Struct::Certificate)
      expect(result.id).to be_a(Fixnum)
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:put, %r[/v1]).
            to_return(read_fixture("certificates/notfound.http"))

        expect {
          subject.submit("example.com", 2, "admin@example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
