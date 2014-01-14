require 'spec_helper'

describe DNSimple::Certificate do

  let(:domain) { DNSimple::Domain.new(:name => "example.com") }


  describe ".find" do
    before do
      stub_request(:get, %r[/domains/example.com/certificates/2]).
          to_return(read_fixture("certificates/show/success.http"))
    end

    it "builds the correct request" do
      described_class.find(domain, "2")

      WebMock.should have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@api.sandbox.dnsimple.com/domains/example.com/certificates/2").
                         with(:headers => { 'Accept' => 'application/json' })
    end

    context "when the certificate exists" do
      it "returns the certificate" do
        result = described_class.find(domain, "2")

        expect(result.id).to eq(4576)
        expect(result.domain).to eq(domain)
        expect(result.name).to eq("www")
        expect(result.csr).to eq("-----BEGIN NEW CERTIFICATE REQUEST-----\nRHr2akB4KMba6FMAsvlStnO/2ika16hNx+d3smPNsER+HA==\n-----END NEW CERTIFICATE REQUEST-----\n")
        expect(result.ssl_certificate).to eq("-----BEGIN CERTIFICATE-----\nXwTkw5UCPpaVyUYcwHlvaprOe9ZbwIyEHm2AT1rW+70=\n-----END CERTIFICATE-----\n")
        expect(result.private_key).to eq("-----BEGIN RSA PRIVATE KEY-----\nUeXbFi7o+nuPfRhpBFQEKwacKFc3Hnc1hH6UsnC0KY25cUif7yz38A==\n-----END RSA PRIVATE KEY-----\n")
        expect(result.approver_email).to eq("example@example.net")
        expect(result.created_at).to eq("2013-09-17T21:54:42Z")
        expect(result.updated_at).to eq("2013-09-17T22:25:36Z")

        expect(result.available_approver_emails).to be_nil
        expect(result.certificate_status).to be_nil
      end
    end
  end


  describe "#fqdn" do
    it "joins the name and domain name" do
      certificate = described_class.new(:name => 'www')
      certificate.domain = domain
      expect(certificate.fqdn).to eq("www.#{domain.name}")
    end

    it "strips blank parts from name" do
      certificate = described_class.new(:name => '')
      certificate.domain = domain
      expect(certificate.fqdn).to eq(domain.name)
    end
  end

end
