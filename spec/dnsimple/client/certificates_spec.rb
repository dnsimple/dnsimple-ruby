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

  describe "#certificate" do
    let(:account_id)     { 1010 }
    let(:domain_id)      { "weppos.net" }
    let(:certificate_id) { 1 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}}).
          to_return(read_http_fixture("getCertificate/success.http"))
    end

    it "builds the correct request" do
      subject.certificate(account_id, domain_id, certificate_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}").
          with(headers: { 'Accept' => 'application/json' })
    end

    it "supports extra request options" do
      subject.certificate(account_id, domain_id, certificate_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}?foo=bar")
    end

    it "returns the certificate" do
      response = subject.certificate(account_id, domain_id, certificate_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Certificate)
      expect(result.id).to eq(1)
      expect(result.domain_id).to eq(2)
      expect(result.name).to eq("www")
      expect(result.common_name).to eq("www.weppos.net")
      expect(result.years).to eq(1)
      expect(result.csr).to eq("-----BEGIN CERTIFICATE REQUEST-----\nMIICljCCAX4CAQAwGTEXMBUGA1UEAwwOd3d3LndlcHBvcy5uZXQwggEiMA0GCSqG\nSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC3MJwx9ahBG3kAwRjQdRvYZqtovUaxY6jp\nhd09975gO+2eYPDbc1yhNftVJ4KBT0zdEqzX0CwIlxE1MsnZ2YOsC7IJO531hMBp\ndBxM4tSG07xPz70AVUi9rY6YCUoJHmxoFbclpHFbtXZocR393WyzUK8047uM2mlz\n03AZKcMdyfeuo2/9TcxpTSCkklGqwqS9wtTogckaDHJDoBunAkMioGfOSMe7Yi6E\nYRtG4yPJYsDaq2yPJWV8+i0PFR1Wi5RCnPt0YdQWstHuZrxABi45+XVkzKtz3TUc\nYxrvPBucVa6uzd953u8CixNFkiOefvb/dajsv1GIwH6/Cvc1ftz1AgMBAAGgODA2\nBgkqhkiG9w0BCQ4xKTAnMCUGA1UdEQQeMByCDnd3dy53ZXBwb3MubmV0ggp3ZXBw\nb3MubmV0MA0GCSqGSIb3DQEBCwUAA4IBAQCDnVBO9RdJX0eFeZzlv5c8yG8duhKP\nl0Vl+V88fJylb/cbNj9qFPkKTK0vTXmS2XUFBChKPtLucp8+Z754UswX+QCsdc7U\nTTSG0CkyilcSubdZUERGej1XfrVQhrokk7Fu0Jh3BdT6REP0SIDTpA8ku/aRQiAp\np+h19M37S7+w/DMGDAq2LSX8jOpJ1yIokRDyLZpmwyLxutC21DXMGoJ3xZeUFrUT\nqRNwzkn2dJzgTrPkzhaXalUBqv+nfXHqHaWljZa/O0NVCFrHCdTdd53/6EE2Yabv\nq5SFTkRCpaxrvM/7a8Tr4ixD1/VKD6rw3+WC00000000000000000000\n-----END CERTIFICATE REQUEST-----\n")
      expect(result.state).to eq("issued")
      expect(result.authority_identifier).to eq("letsencrypt")
      expect(result.created_at).to eq("2016-06-11T18:47:08.949Z")
      expect(result.updated_at).to eq("2016-06-11T18:47:37.546Z")
      expect(result.expires_on).to eq("2016-09-09")
    end

    context "when the certificate does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2}).
            to_return(read_http_fixture("notfound-certificate.http"))

        expect {
          subject.certificate(account_id, domain_id, certificate_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
