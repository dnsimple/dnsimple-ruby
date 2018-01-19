require 'spec_helper'

describe Dnsimple::Client, ".certificates" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").certificates }

  describe "#certificates" do
    let(:account_id) { 1010 }
    let(:domain_id)  { "example.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/certificates})
          .to_return(read_http_fixture("listCertificates/success.http"))
    end

    it "builds the correct request" do
      subject.certificates(account_id, domain_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates")
          .with(headers: { 'Accept' => 'application/json' })
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
        expect(result.id).to be_a(Integer)
      end
    end

    it "exposes the pagination information" do
      response = subject.certificates(account_id, domain_id)

      expect(response.respond_to?(:page)).to be_truthy
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Integer)
      expect(response.total_entries).to be_a(Integer)
      expect(response.total_pages).to be_a(Integer)
    end
  end

  describe "#all_certificates" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/certificates})
          .to_return(read_http_fixture("listCertificates/success.http"))
    end

    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:certificates, account_id, domain_id, foo: "bar")
      subject.all_certificates(account_id, domain_id, foo: "bar")
    end

    it "supports sorting" do
      subject.all_certificates(account_id, domain_id, sort: "id:asc,expires_on:desc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates?page=1&per_page=100&sort=id:asc,expires_on:desc")
    end
  end

  describe "#certificate" do
    let(:account_id)     { 1010 }
    let(:domain_id)      { "weppos.net" }
    let(:certificate_id) { 1 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}})
          .to_return(read_http_fixture("getCertificate/success.http"))
    end

    it "builds the correct request" do
      subject.certificate(account_id, domain_id, certificate_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}")
          .with(headers: { 'Accept' => 'application/json' })
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
      expect(result.contact_id).to eq(3)
      expect(result.common_name).to eq("www.weppos.net")
      expect(result.alternate_names).to eq(%w( weppos.net www.weppos.net ))
      expect(result.years).to eq(1)
      expect(result.csr).to eq("-----BEGIN CERTIFICATE REQUEST-----\nMIICljCCAX4CAQAwGTEXMBUGA1UEAwwOd3d3LndlcHBvcy5uZXQwggEiMA0GCSqG\nSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC3MJwx9ahBG3kAwRjQdRvYZqtovUaxY6jp\nhd09975gO+2eYPDbc1yhNftVJ4KBT0zdEqzX0CwIlxE1MsnZ2YOsC7IJO531hMBp\ndBxM4tSG07xPz70AVUi9rY6YCUoJHmxoFbclpHFbtXZocR393WyzUK8047uM2mlz\n03AZKcMdyfeuo2/9TcxpTSCkklGqwqS9wtTogckaDHJDoBunAkMioGfOSMe7Yi6E\nYRtG4yPJYsDaq2yPJWV8+i0PFR1Wi5RCnPt0YdQWstHuZrxABi45+XVkzKtz3TUc\nYxrvPBucVa6uzd953u8CixNFkiOefvb/dajsv1GIwH6/Cvc1ftz1AgMBAAGgODA2\nBgkqhkiG9w0BCQ4xKTAnMCUGA1UdEQQeMByCDnd3dy53ZXBwb3MubmV0ggp3ZXBw\nb3MubmV0MA0GCSqGSIb3DQEBCwUAA4IBAQCDnVBO9RdJX0eFeZzlv5c8yG8duhKP\nl0Vl+V88fJylb/cbNj9qFPkKTK0vTXmS2XUFBChKPtLucp8+Z754UswX+QCsdc7U\nTTSG0CkyilcSubdZUERGej1XfrVQhrokk7Fu0Jh3BdT6REP0SIDTpA8ku/aRQiAp\np+h19M37S7+w/DMGDAq2LSX8jOpJ1yIokRDyLZpmwyLxutC21DXMGoJ3xZeUFrUT\nqRNwzkn2dJzgTrPkzhaXalUBqv+nfXHqHaWljZa/O0NVCFrHCdTdd53/6EE2Yabv\nq5SFTkRCpaxrvM/7a8Tr4ixD1/VKD6rw3+WC00000000000000000000\n-----END CERTIFICATE REQUEST-----\n")
      expect(result.state).to eq("issued")
      expect(result.authority_identifier).to eq("letsencrypt")
      expect(result.auto_renew).to be(false)
      expect(result.created_at).to eq("2016-06-11T18:47:08Z")
      expect(result.updated_at).to eq("2016-06-11T18:47:37Z")
      expect(result.expires_on).to eq("2016-09-09")
    end

    context "when the certificate does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-certificate.http"))

        expect {
          subject.certificate(account_id, domain_id, certificate_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#download_certificate" do
    let(:account_id)     { 1010 }
    let(:domain_id)      { "weppos.net" }
    let(:certificate_id) { 1 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/download})
          .to_return(read_http_fixture("downloadCertificate/success.http"))
    end

    it "builds the correct request" do
      subject.download_certificate(account_id, domain_id, certificate_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/download")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports extra request options" do
      subject.download_certificate(account_id, domain_id, certificate_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/download?foo=bar")
    end

    it "returns the certificate bundle" do
      response = subject.download_certificate(account_id, domain_id, certificate_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::CertificateBundle)
      expect(result.private_key).to be_nil
      expect(result.server_certificate).to eq("-----BEGIN CERTIFICATE-----\nMIIE7TCCA9WgAwIBAgITAPpTe4O3vjuQ9L4gLsogi/ukujANBgkqhkiG9w0BAQsF\nADAiMSAwHgYDVQQDDBdGYWtlIExFIEludGVybWVkaWF0ZSBYMTAeFw0xNjA2MTEx\nNzQ4MDBaFw0xNjA5MDkxNzQ4MDBaMBkxFzAVBgNVBAMTDnd3dy53ZXBwb3MubmV0\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtzCcMfWoQRt5AMEY0HUb\n2GaraL1GsWOo6YXdPfe+YDvtnmDw23NcoTX7VSeCgU9M3RKs19AsCJcRNTLJ2dmD\nrAuyCTud9YTAaXQcTOLUhtO8T8+9AFVIva2OmAlKCR5saBW3JaRxW7V2aHEd/d1s\ns1CvNOO7jNppc9NwGSnDHcn3rqNv/U3MaU0gpJJRqsKkvcLU6IHJGgxyQ6AbpwJD\nIqBnzkjHu2IuhGEbRuMjyWLA2qtsjyVlfPotDxUdVouUQpz7dGHUFrLR7ma8QAYu\nOfl1ZMyrc901HGMa7zwbnFWurs3fed7vAosTRZIjnn72/3Wo7L9RiMB+vwr3NX7c\n9QIDAQABo4ICIzCCAh8wDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUF\nBwMBBggrBgEFBQcDAjAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBRh9q/3Zxbk4yA/\nt7j+8xA+rkiZBTAfBgNVHSMEGDAWgBTAzANGuVggzFxycPPhLssgpvVoOjB4Bggr\nBgEFBQcBAQRsMGowMwYIKwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnN0Zy1pbnQteDEu\nbGV0c2VuY3J5cHQub3JnLzAzBggrBgEFBQcwAoYnaHR0cDovL2NlcnQuc3RnLWlu\ndC14MS5sZXRzZW5jcnlwdC5vcmcvMCUGA1UdEQQeMByCCndlcHBvcy5uZXSCDnd3\ndy53ZXBwb3MubmV0MIH+BgNVHSAEgfYwgfMwCAYGZ4EMAQIBMIHmBgsrBgEEAYLf\nEwEBATCB1jAmBggrBgEFBQcCARYaaHR0cDovL2Nwcy5sZXRzZW5jcnlwdC5vcmcw\ngasGCCsGAQUFBwICMIGeDIGbVGhpcyBDZXJ0aWZpY2F0ZSBtYXkgb25seSBiZSBy\nZWxpZWQgdXBvbiBieSBSZWx5aW5nIFBhcnRpZXMgYW5kIG9ubHkgaW4gYWNjb3Jk\nYW5jZSB3aXRoIHRoZSBDZXJ0aWZpY2F0ZSBQb2xpY3kgZm91bmQgYXQgaHR0cHM6\nLy9sZXRzZW5jcnlwdC5vcmcvcmVwb3NpdG9yeS8wDQYJKoZIhvcNAQELBQADggEB\nAEqMdWrmdIyQxthWsX3iHmM2h/wXwEesD0VIaA+Pq4mjwmKBkoPSmHGQ/O4v8RaK\nB6gl8v+qmvCwwqC1SkBmm+9C2yt/P6WhAiA/DD+WppYgJWfcz2lEKrgufFlHPukB\nDzE0mJDuXm09QTApWlaTZWYfWKY50T5uOT/rs+OwGFFCO/8o7v5AZRAHos6uzjvq\nAtFZj/FEnXXMjSSlQ7YKTXToVpnAYH4e3/UMsi6/O4orkVz82ZfhKwMWHV8dXlRw\ntQaemFWTjGPgSLXJAtQO30DgNJBHX/fJEaHv6Wy8TF3J0wOGpzGbOwaTX8YAmEzC\nlzzjs+clg5MN5rd1g4POJtU=\n-----END CERTIFICATE-----\n")
      expect(result.root_certificate).to be_nil
      expect(result.intermediate_certificates).to eq(["-----BEGIN CERTIFICATE-----\nMIIEqzCCApOgAwIBAgIRAIvhKg5ZRO08VGQx8JdhT+UwDQYJKoZIhvcNAQELBQAw\nGjEYMBYGA1UEAwwPRmFrZSBMRSBSb290IFgxMB4XDTE2MDUyMzIyMDc1OVoXDTM2\nMDUyMzIyMDc1OVowIjEgMB4GA1UEAwwXRmFrZSBMRSBJbnRlcm1lZGlhdGUgWDEw\nggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDtWKySDn7rWZc5ggjz3ZB0\n8jO4xti3uzINfD5sQ7Lj7hzetUT+wQob+iXSZkhnvx+IvdbXF5/yt8aWPpUKnPym\noLxsYiI5gQBLxNDzIec0OIaflWqAr29m7J8+NNtApEN8nZFnf3bhehZW7AxmS1m0\nZnSsdHw0Fw+bgixPg2MQ9k9oefFeqa+7Kqdlz5bbrUYV2volxhDFtnI4Mh8BiWCN\nxDH1Hizq+GKCcHsinDZWurCqder/afJBnQs+SBSL6MVApHt+d35zjBD92fO2Je56\ndhMfzCgOKXeJ340WhW3TjD1zqLZXeaCyUNRnfOmWZV8nEhtHOFbUCU7r/KkjMZO9\nAgMBAAGjgeMwgeAwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAw\nHQYDVR0OBBYEFMDMA0a5WCDMXHJw8+EuyyCm9Wg6MHoGCCsGAQUFBwEBBG4wbDA0\nBggrBgEFBQcwAYYoaHR0cDovL29jc3Auc3RnLXJvb3QteDEubGV0c2VuY3J5cHQu\nb3JnLzA0BggrBgEFBQcwAoYoaHR0cDovL2NlcnQuc3RnLXJvb3QteDEubGV0c2Vu\nY3J5cHQub3JnLzAfBgNVHSMEGDAWgBTBJnSkikSg5vogKNhcI5pFiBh54DANBgkq\nhkiG9w0BAQsFAAOCAgEABYSu4Il+fI0MYU42OTmEj+1HqQ5DvyAeyCA6sGuZdwjF\nUGeVOv3NnLyfofuUOjEbY5irFCDtnv+0ckukUZN9lz4Q2YjWGUpW4TTu3ieTsaC9\nAFvCSgNHJyWSVtWvB5XDxsqawl1KzHzzwr132bF2rtGtazSqVqK9E07sGHMCf+zp\nDQVDVVGtqZPHwX3KqUtefE621b8RI6VCl4oD30Olf8pjuzG4JKBFRFclzLRjo/h7\nIkkfjZ8wDa7faOjVXx6n+eUQ29cIMCzr8/rNWHS9pYGGQKJiY2xmVC9h12H99Xyf\nzWE9vb5zKP3MVG6neX1hSdo7PEAb9fqRhHkqVsqUvJlIRmvXvVKTwNCP3eCjRCCI\nPTAvjV+4ni786iXwwFYNz8l3PmPLCyQXWGohnJ8iBm+5nk7O2ynaPVW0U2W+pt2w\nSVuvdDM5zGv2f9ltNWUiYZHJ1mmO97jSY/6YfdOUH66iRtQtDkHBRdkNBsMbD+Em\n2TgBldtHNSJBfB3pm9FblgOcJ0FSWcUDWJ7vO0+NTXlgrRofRT6pVywzxVo6dND0\nWzYlTWeUVsO40xJqhgUQRER9YLOLxJ0O6C8i0xFxAMKOtSdodMB3RIwt7RFQ0uyt\nn5Z5MqkYhlMI3J1tPRTp1nEt9fyGspBOO05gi148Qasp+3N+svqKomoQglNoAxU=\n-----END CERTIFICATE-----"])
    end

    context "when the certificate does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-certificate.http"))

        expect {
          subject.download_certificate(account_id, domain_id, certificate_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#certificate_private_key" do
    let(:account_id)     { 1010 }
    let(:domain_id)      { "weppos.net" }
    let(:certificate_id) { 1 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/private_key})
          .to_return(read_http_fixture("getCertificatePrivateKey/success.http"))
    end

    it "builds the correct request" do
      subject.certificate_private_key(account_id, domain_id, certificate_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/private_key")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports extra request options" do
      subject.certificate_private_key(account_id, domain_id, certificate_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/private_key?foo=bar")
    end

    it "returns the certificate bundle" do
      response = subject.certificate_private_key(account_id, domain_id, certificate_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::CertificateBundle)
      expect(result.private_key).to eq("-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAtzCcMfWoQRt5AMEY0HUb2GaraL1GsWOo6YXdPfe+YDvtnmDw\n23NcoTX7VSeCgU9M3RKs19AsCJcRNTLJ2dmDrAuyCTud9YTAaXQcTOLUhtO8T8+9\nAFVIva2OmAlKCR5saBW3JaRxW7V2aHEd/d1ss1CvNOO7jNppc9NwGSnDHcn3rqNv\n/U3MaU0gpJJRqsKkvcLU6IHJGgxyQ6AbpwJDIqBnzkjHu2IuhGEbRuMjyWLA2qts\njyVlfPotDxUdVouUQpz7dGHUFrLR7ma8QAYuOfl1ZMyrc901HGMa7zwbnFWurs3f\ned7vAosTRZIjnn72/3Wo7L9RiMB+vwr3NX7c9QIDAQABAoIBAEQx32OlzK34GTKT\nr7Yicmw7xEGofIGa1Q2h3Lut13whsxKLif5X0rrcyqRnoeibacS+qXXrJolIG4rP\nTl8/3wmUDQHs5J+6fJqFM+fXZUCP4AFiFzzhgsPBsVyd0KbWYYrZ0qU7s0ttoRe+\nTGjuHgIe3ip1QKNtx2Xr50YmytDydknmro79J5Gfrub1l2iA8SDm1eBrQ4SFaNQ2\nU709pHeSwX8pTihUX2Zy0ifpr0O1wYQjGLneMoG4rrNQJG/z6iUdhYczwwt1kDRQ\n4WkM2sovFOyxbBfoCQ3Gy/eem7OXfjNKUe47DAVLnPkKbqL/3Lo9FD7kcB8K87Ap\nr/vYrl0CgYEA413RAk7571w5dM+VftrdbFZ+Yi1OPhUshlPSehavro8kMGDEG5Ts\n74wEz2X3cfMxauMpMrBk/XnUCZ20AnWQClK73RB5fzPw5XNv473Tt/AFmt7eLOzl\nOcYrhpEHegtsD/ZaljlGtPqsjQAL9Ijhao03m1cGB1+uxI7FgacdckcCgYEAzkKP\n6xu9+WqOol73cnlYPS3sSZssyUF+eqWSzq2YJGRmfr1fbdtHqAS1ZbyC5fZVNZYV\nml1vfXi2LDcU0qS04JazurVyQr2rJZMTlCWVET1vhik7Y87wgCkLwKpbwamPDmlI\n9GY+fLNEa4yfAOOpvpTJpenUScxyKWH2cdYFOOMCgYBhrJnvffINC/d64Pp+BpP8\nyKN+lav5K6t3AWd4H2rVeJS5W7ijiLTIq8QdPNayUyE1o+S8695WrhGTF/aO3+ZD\nKQufikZHiQ7B43d7xL7BVBF0WK3lateGnEVyh7dIjMOdj92Wj4B6mv2pjQ2VvX/p\nAEWVLCtg24/+zL64VgxmXQKBgGosyXj1Zu2ldJcQ28AJxup3YVLilkNje4AXC2No\n6RCSvlAvm5gpcNGE2vvr9lX6YBKdl7FGt8WXBe/sysNEFfgmm45ZKOBCUn+dHk78\nqaeeQHKHdxMBy7utZWdgSqt+ZS299NgaacA3Z9kVIiSLDS4V2VeW7riujXXP/9TJ\nnxaRAoGBAMWXOfNVzfTyrKff6gvDWH+hqNICLyzvkEn2utNY9Q6WwqGuY9fvP/4Z\nXzc48AOBzUr8OeA4sHKJ79sJirOiWHNfD1swtvyVzsFZb6moiNwD3Ce/FzYCa3lQ\nU8blTH/uqpR2pSC6whzJ/lnSdqHUqhyp00000000000000000000\n-----END RSA PRIVATE KEY-----\n")
      expect(result.server_certificate).to be_nil
      expect(result.root_certificate).to be_nil
      expect(result.intermediate_certificates).to be_nil
    end

    context "when the certificate does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-certificate.http"))

        expect {
          subject.certificate_private_key(account_id, domain_id, certificate_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#purchase_letsencrypt_certificate" do
    let(:account_id) { 1010 }
    let(:domain_id)  { "example.com" }
    let(:contact_id) { 100 }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/certificates/letsencrypt})
          .to_return(read_http_fixture("purchaseLetsencryptCertificate/success.http"))
    end

    it "builds the correct request" do
      attributes = { contact_id: contact_id }
      subject.purchase_letsencrypt_certificate(account_id, domain_id, attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/letsencrypt")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "passes extra attributes" do
      attributes = { contact_id: contact_id, name: "www", auto_renew: true, alternate_names: ["api.example.com"] }
      subject.purchase_letsencrypt_certificate(account_id, domain_id, attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/letsencrypt")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the certificate purchase" do
      response = subject.purchase_letsencrypt_certificate(account_id, domain_id, contact_id: contact_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::CertificatePurchase)

      expect(result.id).to eq(300)
      expect(result.certificate_id).to eq(300)
      expect(result.state).to eq("requesting")
      expect(result.auto_renew).to be(false)
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.purchase_letsencrypt_certificate(account_id, domain_id, contact_id: contact_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#issue_letsencrypt_certificate" do
    let(:account_id) { 1010 }
    let(:domain_id)  { "example.com" }
    let(:certificate_id) { 200 }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/issue})
          .to_return(read_http_fixture("issueLetsencryptCertificate/success.http"))
    end

    it "builds the correct request" do
      subject.issue_letsencrypt_certificate(account_id, domain_id, certificate_id)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/issue")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the certificate" do
      response = subject.issue_letsencrypt_certificate(account_id, domain_id, certificate_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Certificate)

      expect(result.id).to eq(200)
      expect(result.domain_id).to eq(300)
      expect(result.common_name).to eq("www.example.com")
      expect(result.alternate_names).to eq([])
      expect(result.years).to eq(1)
      expect(result.csr).to be(nil)
      expect(result.state).to eq("requesting")
      expect(result.authority_identifier).to eq("letsencrypt")
      expect(result.auto_renew).to be(false)
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.issue_letsencrypt_certificate(account_id, domain_id, certificate_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end

    context "when the certificate does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-certificate.http"))

        expect {
          subject.issue_letsencrypt_certificate(account_id, domain_id, certificate_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#purchase_letsencrypt_certificate_renewal" do
    let(:account_id) { 1010 }
    let(:domain_id)  { "example.com" }
    let(:certificate_id) { 200 }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals})
          .to_return(read_http_fixture("purchaseRenewalLetsencryptCertificate/success.http"))
    end

    it "builds the correct request" do
      subject.purchase_letsencrypt_certificate_renewal(account_id, domain_id, certificate_id)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "passes extra attributes" do
      attributes = { auto_renew: true }
      subject.purchase_letsencrypt_certificate_renewal(account_id, domain_id, certificate_id, attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the certificate renew" do
      response = subject.purchase_letsencrypt_certificate_renewal(account_id, domain_id, certificate_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::CertificateRenewal)

      expect(result.id).to eq(999)
      expect(result.old_certificate_id).to eq(certificate_id)
      expect(result.new_certificate_id).to eq(300)
      expect(result.state).to eq("new")
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.purchase_letsencrypt_certificate_renewal(account_id, domain_id, certificate_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#issue_letsencrypt_certificate_renewal" do
    let(:account_id) { 1010 }
    let(:domain_id)  { "example.com" }
    let(:certificate_id) { 300 }
    let(:certificate_renewal_id) { 999 }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals/#{certificate_renewal_id}/issue})
          .to_return(read_http_fixture("issueRenewalLetsencryptCertificate/success.http"))
    end

    it "builds the correct request" do
      subject.issue_letsencrypt_certificate_renewal(account_id, domain_id, certificate_id, certificate_renewal_id)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals/#{certificate_renewal_id}/issue")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the certificate" do
      response = subject.issue_letsencrypt_certificate_renewal(account_id, domain_id, certificate_id, certificate_renewal_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Certificate)

      expect(result.id).to eq(300)
      expect(result.domain_id).to eq(300)
      expect(result.common_name).to eq("www.example.com")
      expect(result.alternate_names).to eq([])
      expect(result.years).to eq(1)
      expect(result.csr).to be(nil)
      expect(result.state).to eq("requesting")
      expect(result.authority_identifier).to eq("letsencrypt")
      expect(result.auto_renew).to be(false)
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.issue_letsencrypt_certificate_renewal(account_id, domain_id, certificate_id, certificate_renewal_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end

    context "when the certificate does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-certificate.http"))

        expect {
          subject.issue_letsencrypt_certificate_renewal(account_id, domain_id, certificate_id, certificate_renewal_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
