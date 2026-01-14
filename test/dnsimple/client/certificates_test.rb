# frozen_string_literal: true

require "test_helper"

class CertificatesTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").certificates
    @account_id = 1010
  end


  def test_certificates_builds_correct_request
    domain_id = "example.com"
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates})
        .to_return(read_http_fixture("listCertificates/success.http"))

    @subject.certificates(@account_id, domain_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates",
                     headers: { "Accept" => "application/json" })
  end

  def test_certificates_supports_pagination
    domain_id = "example.com"
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates})
        .to_return(read_http_fixture("listCertificates/success.http"))

    @subject.certificates(@account_id, domain_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates?page=2")
  end

  def test_certificates_supports_extra_request_options
    domain_id = "example.com"
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates})
        .to_return(read_http_fixture("listCertificates/success.http"))

    @subject.certificates(@account_id, domain_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates?foo=bar")
  end

  def test_certificates_returns_the_certificates
    domain_id = "example.com"
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates})
        .to_return(read_http_fixture("listCertificates/success.http"))

    response = @subject.certificates(@account_id, domain_id)

    assert_kind_of(Dnsimple::PaginatedResponse, response)
    assert_kind_of(Array, response.data)
    assert_equal(2, response.data.size)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::Certificate, result)
      assert_kind_of(Integer, result.id)
    end
  end

  def test_certificates_exposes_the_pagination_information
    domain_id = "example.com"
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates})
        .to_return(read_http_fixture("listCertificates/success.http"))

    response = @subject.certificates(@account_id, domain_id)

    assert_respond_to(response, :page)
    assert_equal(1, response.page)
    assert_kind_of(Integer, response.per_page)
    assert_kind_of(Integer, response.total_entries)
    assert_kind_of(Integer, response.total_pages)
  end


  def test_all_certificates_delegates_to_client_paginate
    domain_id = "dnsimple.us"
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates})
        .to_return(read_http_fixture("listCertificates/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:certificates, @account_id, domain_id, { foo: "bar" }])
    @subject.stub(:paginate, mock) do
      @subject.all_certificates(@account_id, domain_id, { foo: "bar" })
    end
    mock.verify
  end

  def test_all_certificates_supports_sorting
    domain_id = "dnsimple.us"
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates})
        .to_return(read_http_fixture("listCertificates/success.http"))

    @subject.all_certificates(@account_id, domain_id, sort: "id:asc,expiration:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates?page=1&per_page=100&sort=id:asc,expiration:desc")
  end


  def test_certificate_builds_correct_request
    domain_id = "bingo.pizza"
    certificate_id = 101967
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}})
        .to_return(read_http_fixture("getCertificate/success.http"))

    @subject.certificate(@account_id, domain_id, certificate_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_certificate_supports_extra_request_options
    domain_id = "bingo.pizza"
    certificate_id = 101967
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}})
        .to_return(read_http_fixture("getCertificate/success.http"))

    @subject.certificate(@account_id, domain_id, certificate_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}?foo=bar")
  end

  def test_certificate_returns_the_certificate
    domain_id = "bingo.pizza"
    certificate_id = 101967
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}})
        .to_return(read_http_fixture("getCertificate/success.http"))

    response = @subject.certificate(@account_id, domain_id, certificate_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Certificate, result)
    assert_equal(101967, result.id)
    assert_equal(289333, result.domain_id)
    assert_equal(2511, result.contact_id)
    assert_equal("www.bingo.pizza", result.common_name)
    assert_empty(result.alternate_names)
    assert_equal(1, result.years)
    assert_equal("-----BEGIN CERTIFICATE REQUEST-----\nMIICmTCCAYECAQAwGjEYMBYGA1UEAwwPd3d3LmJpbmdvLnBpenphMIIBIjANBgkq\nhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAw4+KoZ9IDCK2o5qAQpi+Icu5kksmjQzx\n5o5g4B6XhRxhsfHlK/i3iU5hc8CONjyVv8j82835RNsiKrflnxGa9SH68vbQfcn4\nIpbMz9c+Eqv5h0Euqlc3A4DBzp0unEu5QAUhR6Xu1TZIWDPjhrBOGiszRlLQcp4F\nzy6fD6j5/d/ylpzTp5v54j+Ey31Bz86IaBPtSpHI+Qk87Hs8DVoWxZk/6RlAkyur\nXDGWnPu9n3RMfs9ag5anFhggLIhCNtVN4+0vpgPQ59pqwYo8TfdYzK7WSKeL7geu\nCqVE3bHAqU6dLtgHOZfTkLwGycUh4p9aawuc6fsXHHYDpIL8s3vAvwIDAQABoDow\nOAYJKoZIhvcNAQkOMSswKTAnBgNVHREEIDAeggtiaW5nby5waXp6YYIPd3d3LmJp\nbmdvLnBpenphMA0GCSqGSIb3DQEBCwUAA4IBAQBwOLKv+PO5hSJkgqS6wL/wRqLh\nQ1zbcHRHAjRjnpRz06cDvN3X3aPI+lpKSNFCI0A1oKJG7JNtgxX3Est66cuO8ESQ\nPIb6WWN7/xlVlBCe7ZkjAFgN6JurFdclwCp/NI5wBCwj1yb3Ar5QQMFIZOezIgTI\nAWkQSfCmgkB96d6QlDWgidYDDjcsXugQveOQRPlHr0TsElu47GakxZdJCFZU+WPM\nodQQf5SaqiIK2YaH1dWO//4KpTS9QoTy1+mmAa27apHcmz6X6+G5dvpHZ1qH14V0\nJoMWIK+39HRPq6mDo1UMVet/xFUUrG/H7/tFlYIDVbSpVlpVAFITd/eQkaW/\n-----END CERTIFICATE REQUEST-----\n", result.csr)
    assert_equal("issued", result.state)
    assert_equal("letsencrypt", result.authority_identifier)
    refute(result.auto_renew)
    assert_equal("2020-06-18T18:54:17Z", result.created_at)
    assert_equal("2020-06-18T19:10:14Z", result.updated_at)
    assert_equal("2020-09-16T18:10:13Z", result.expires_at)
  end

  def test_certificate_when_certificate_does_not_exist_raises_not_found_error
    domain_id = "bingo.pizza"
    certificate_id = 101967
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-certificate.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.certificate(@account_id, domain_id, certificate_id)
    end
  end


  def test_download_certificate_builds_correct_request
    domain_id = "weppos.net"
    certificate_id = 1
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}/download})
        .to_return(read_http_fixture("downloadCertificate/success.http"))

    @subject.download_certificate(@account_id, domain_id, certificate_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}/download",
                     headers: { "Accept" => "application/json" })
  end

  def test_download_certificate_supports_extra_request_options
    domain_id = "weppos.net"
    certificate_id = 1
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}/download})
        .to_return(read_http_fixture("downloadCertificate/success.http"))

    @subject.download_certificate(@account_id, domain_id, certificate_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}/download?foo=bar")
  end

  def test_download_certificate_returns_the_certificate_bundle
    domain_id = "weppos.net"
    certificate_id = 1
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}/download})
        .to_return(read_http_fixture("downloadCertificate/success.http"))

    response = @subject.download_certificate(@account_id, domain_id, certificate_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::CertificateBundle, result)
    assert_nil(result.private_key)
    assert_equal("-----BEGIN CERTIFICATE-----\nMIIE7TCCA9WgAwIBAgITAPpTe4O3vjuQ9L4gLsogi/ukujANBgkqhkiG9w0BAQsF\nADAiMSAwHgYDVQQDDBdGYWtlIExFIEludGVybWVkaWF0ZSBYMTAeFw0xNjA2MTEx\nNzQ4MDBaFw0xNjA5MDkxNzQ4MDBaMBkxFzAVBgNVBAMTDnd3dy53ZXBwb3MubmV0\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtzCcMfWoQRt5AMEY0HUb\n2GaraL1GsWOo6YXdPfe+YDvtnmDw23NcoTX7VSeCgU9M3RKs19AsCJcRNTLJ2dmD\nrAuyCTud9YTAaXQcTOLUhtO8T8+9AFVIva2OmAlKCR5saBW3JaRxW7V2aHEd/d1s\ns1CvNOO7jNppc9NwGSnDHcn3rqNv/U3MaU0gpJJRqsKkvcLU6IHJGgxyQ6AbpwJD\nIqBnzkjHu2IuhGEbRuMjyWLA2qtsjyVlfPotDxUdVouUQpz7dGHUFrLR7ma8QAYu\nOfl1ZMyrc901HGMa7zwbnFWurs3fed7vAosTRZIjnn72/3Wo7L9RiMB+vwr3NX7c\n9QIDAQABo4ICIzCCAh8wDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUF\nBwMBBggrBgEFBQcDAjAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBRh9q/3Zxbk4yA/\nt7j+8xA+rkiZBTAfBgNVHSMEGDAWgBTAzANGuVggzFxycPPhLssgpvVoOjB4Bggr\nBgEFBQcBAQRsMGowMwYIKwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnN0Zy1pbnQteDEu\nbGV0c2VuY3J5cHQub3JnLzAzBggrBgEFBQcwAoYnaHR0cDovL2NlcnQuc3RnLWlu\ndC14MS5sZXRzZW5jcnlwdC5vcmcvMCUGA1UdEQQeMByCCndlcHBvcy5uZXSCDnd3\ndy53ZXBwb3MubmV0MIH+BgNVHSAEgfYwgfMwCAYGZ4EMAQIBMIHmBgsrBgEEAYLf\nEwEBATCB1jAmBggrBgEFBQcCARYaaHR0cDovL2Nwcy5sZXRzZW5jcnlwdC5vcmcw\ngasGCCsGAQUFBwICMIGeDIGbVGhpcyBDZXJ0aWZpY2F0ZSBtYXkgb25seSBiZSBy\nZWxpZWQgdXBvbiBieSBSZWx5aW5nIFBhcnRpZXMgYW5kIG9ubHkgaW4gYWNjb3Jk\nYW5jZSB3aXRoIHRoZSBDZXJ0aWZpY2F0ZSBQb2xpY3kgZm91bmQgYXQgaHR0cHM6\nLy9sZXRzZW5jcnlwdC5vcmcvcmVwb3NpdG9yeS8wDQYJKoZIhvcNAQELBQADggEB\nAEqMdWrmdIyQxthWsX3iHmM2h/wXwEesD0VIaA+Pq4mjwmKBkoPSmHGQ/O4v8RaK\nB6gl8v+qmvCwwqC1SkBmm+9C2yt/P6WhAiA/DD+WppYgJWfcz2lEKrgufFlHPukB\nDzE0mJDuXm09QTApWlaTZWYfWKY50T5uOT/rs+OwGFFCO/8o7v5AZRAHos6uzjvq\nAtFZj/FEnXXMjSSlQ7YKTXToVpnAYH4e3/UMsi6/O4orkVz82ZfhKwMWHV8dXlRw\ntQaemFWTjGPgSLXJAtQO30DgNJBHX/fJEaHv6Wy8TF3J0wOGpzGbOwaTX8YAmEzC\nlzzjs+clg5MN5rd1g4POJtU=\n-----END CERTIFICATE-----\n", result.server_certificate)
    assert_nil(result.root_certificate)
    assert_equal(["-----BEGIN CERTIFICATE-----\nMIIEqzCCApOgAwIBAgIRAIvhKg5ZRO08VGQx8JdhT+UwDQYJKoZIhvcNAQELBQAw\nGjEYMBYGA1UEAwwPRmFrZSBMRSBSb290IFgxMB4XDTE2MDUyMzIyMDc1OVoXDTM2\nMDUyMzIyMDc1OVowIjEgMB4GA1UEAwwXRmFrZSBMRSBJbnRlcm1lZGlhdGUgWDEw\nggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDtWKySDn7rWZc5ggjz3ZB0\n8jO4xti3uzINfD5sQ7Lj7hzetUT+wQob+iXSZkhnvx+IvdbXF5/yt8aWPpUKnPym\noLxsYiI5gQBLxNDzIec0OIaflWqAr29m7J8+NNtApEN8nZFnf3bhehZW7AxmS1m0\nZnSsdHw0Fw+bgixPg2MQ9k9oefFeqa+7Kqdlz5bbrUYV2volxhDFtnI4Mh8BiWCN\nxDH1Hizq+GKCcHsinDZWurCqder/afJBnQs+SBSL6MVApHt+d35zjBD92fO2Je56\ndhMfzCgOKXeJ340WhW3TjD1zqLZXeaCyUNRnfOmWZV8nEhtHOFbUCU7r/KkjMZO9\nAgMBAAGjgeMwgeAwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAw\nHQYDVR0OBBYEFMDMA0a5WCDMXHJw8+EuyyCm9Wg6MHoGCCsGAQUFBwEBBG4wbDA0\nBggrBgEFBQcwAYYoaHR0cDovL29jc3Auc3RnLXJvb3QteDEubGV0c2VuY3J5cHQu\nb3JnLzA0BggrBgEFBQcwAoYoaHR0cDovL2NlcnQuc3RnLXJvb3QteDEubGV0c2Vu\nY3J5cHQub3JnLzAfBgNVHSMEGDAWgBTBJnSkikSg5vogKNhcI5pFiBh54DANBgkq\nhkiG9w0BAQsFAAOCAgEABYSu4Il+fI0MYU42OTmEj+1HqQ5DvyAeyCA6sGuZdwjF\nUGeVOv3NnLyfofuUOjEbY5irFCDtnv+0ckukUZN9lz4Q2YjWGUpW4TTu3ieTsaC9\nAFvCSgNHJyWSVtWvB5XDxsqawl1KzHzzwr132bF2rtGtazSqVqK9E07sGHMCf+zp\nDQVDVVGtqZPHwX3KqUtefE621b8RI6VCl4oD30Olf8pjuzG4JKBFRFclzLRjo/h7\nIkkfjZ8wDa7faOjVXx6n+eUQ29cIMCzr8/rNWHS9pYGGQKJiY2xmVC9h12H99Xyf\nzWE9vb5zKP3MVG6neX1hSdo7PEAb9fqRhHkqVsqUvJlIRmvXvVKTwNCP3eCjRCCI\nPTAvjV+4ni786iXwwFYNz8l3PmPLCyQXWGohnJ8iBm+5nk7O2ynaPVW0U2W+pt2w\nSVuvdDM5zGv2f9ltNWUiYZHJ1mmO97jSY/6YfdOUH66iRtQtDkHBRdkNBsMbD+Em\n2TgBldtHNSJBfB3pm9FblgOcJ0FSWcUDWJ7vO0+NTXlgrRofRT6pVywzxVo6dND0\nWzYlTWeUVsO40xJqhgUQRER9YLOLxJ0O6C8i0xFxAMKOtSdodMB3RIwt7RFQ0uyt\nn5Z5MqkYhlMI3J1tPRTp1nEt9fyGspBOO05gi148Qasp+3N+svqKomoQglNoAxU=\n-----END CERTIFICATE-----"], result.intermediate_certificates)
  end

  def test_download_certificate_when_certificate_does_not_exist_raises_not_found_error
    domain_id = "weppos.net"
    certificate_id = 1
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-certificate.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.download_certificate(@account_id, domain_id, certificate_id)
    end
  end


  def test_certificate_private_key_builds_correct_request
    domain_id = "weppos.net"
    certificate_id = 1
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}/private_key})
        .to_return(read_http_fixture("getCertificatePrivateKey/success.http"))

    @subject.certificate_private_key(@account_id, domain_id, certificate_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}/private_key",
                     headers: { "Accept" => "application/json" })
  end

  def test_certificate_private_key_supports_extra_request_options
    domain_id = "weppos.net"
    certificate_id = 1
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}/private_key})
        .to_return(read_http_fixture("getCertificatePrivateKey/success.http"))

    @subject.certificate_private_key(@account_id, domain_id, certificate_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}/private_key?foo=bar")
  end

  def test_certificate_private_key_returns_the_certificate_bundle
    domain_id = "weppos.net"
    certificate_id = 1
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/#{certificate_id}/private_key})
        .to_return(read_http_fixture("getCertificatePrivateKey/success.http"))

    response = @subject.certificate_private_key(@account_id, domain_id, certificate_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::CertificateBundle, result)
    assert_equal("-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAtzCcMfWoQRt5AMEY0HUb2GaraL1GsWOo6YXdPfe+YDvtnmDw\n23NcoTX7VSeCgU9M3RKs19AsCJcRNTLJ2dmDrAuyCTud9YTAaXQcTOLUhtO8T8+9\nAFVIva2OmAlKCR5saBW3JaRxW7V2aHEd/d1ss1CvNOO7jNppc9NwGSnDHcn3rqNv\n/U3MaU0gpJJRqsKkvcLU6IHJGgxyQ6AbpwJDIqBnzkjHu2IuhGEbRuMjyWLA2qts\njyVlfPotDxUdVouUQpz7dGHUFrLR7ma8QAYuOfl1ZMyrc901HGMa7zwbnFWurs3f\ned7vAosTRZIjnn72/3Wo7L9RiMB+vwr3NX7c9QIDAQABAoIBAEQx32OlzK34GTKT\nr7Yicmw7xEGofIGa1Q2h3Lut13whsxKLif5X0rrcyqRnoeibacS+qXXrJolIG4rP\nTl8/3wmUDQHs5J+6fJqFM+fXZUCP4AFiFzzhgsPBsVyd0KbWYYrZ0qU7s0ttoRe+\nTGjuHgIe3ip1QKNtx2Xr50YmytDydknmro79J5Gfrub1l2iA8SDm1eBrQ4SFaNQ2\nU709pHeSwX8pTihUX2Zy0ifpr0O1wYQjGLneMoG4rrNQJG/z6iUdhYczwwt1kDRQ\n4WkM2sovFOyxbBfoCQ3Gy/eem7OXfjNKUe47DAVLnPkKbqL/3Lo9FD7kcB8K87Ap\nr/vYrl0CgYEA413RAk7571w5dM+VftrdbFZ+Yi1OPhUshlPSehavro8kMGDEG5Ts\n74wEz2X3cfMxauMpMrBk/XnUCZ20AnWQClK73RB5fzPw5XNv473Tt/AFmt7eLOzl\nOcYrhpEHegtsD/ZaljlGtPqsjQAL9Ijhao03m1cGB1+uxI7FgacdckcCgYEAzkKP\n6xu9+WqOol73cnlYPS3sSZssyUF+eqWSzq2YJGRmfr1fbdtHqAS1ZbyC5fZVNZYV\nml1vfXi2LDcU0qS04JazurVyQr2rJZMTlCWVET1vhik7Y87wgCkLwKpbwamPDmlI\n9GY+fLNEa4yfAOOpvpTJpenUScxyKWH2cdYFOOMCgYBhrJnvffINC/d64Pp+BpP8\nyKN+lav5K6t3AWd4H2rVeJS5W7ijiLTIq8QdPNayUyE1o+S8695WrhGTF/aO3+ZD\nKQufikZHiQ7B43d7xL7BVBF0WK3lateGnEVyh7dIjMOdj92Wj4B6mv2pjQ2VvX/p\nAEWVLCtg24/+zL64VgxmXQKBgGosyXj1Zu2ldJcQ28AJxup3YVLilkNje4AXC2No\n6RCSvlAvm5gpcNGE2vvr9lX6YBKdl7FGt8WXBe/sysNEFfgmm45ZKOBCUn+dHk78\nqaeeQHKHdxMBy7utZWdgSqt+ZS299NgaacA3Z9kVIiSLDS4V2VeW7riujXXP/9TJ\nnxaRAoGBAMWXOfNVzfTyrKff6gvDWH+hqNICLyzvkEn2utNY9Q6WwqGuY9fvP/4Z\nXzc48AOBzUr8OeA4sHKJ79sJirOiWHNfD1swtvyVzsFZb6moiNwD3Ce/FzYCa3lQ\nU8blTH/uqpR2pSC6whzJ/lnSdqHUqhyp00000000000000000000\n-----END RSA PRIVATE KEY-----\n", result.private_key)
    assert_nil(result.server_certificate)
    assert_nil(result.root_certificate)
    assert_nil(result.intermediate_certificates)
  end

  def test_certificate_private_key_when_certificate_does_not_exist_raises_not_found_error
    domain_id = "weppos.net"
    certificate_id = 1
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-certificate.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.certificate_private_key(@account_id, domain_id, certificate_id)
    end
  end


  def test_purchase_letsencrypt_certificate_builds_correct_request
    domain_id = "bingo.pizza"
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt})
        .to_return(read_http_fixture("purchaseLetsencryptCertificate/success.http"))

    attributes = {}
    @subject.purchase_letsencrypt_certificate(@account_id, domain_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_purchase_letsencrypt_certificate_passes_extra_attributes
    domain_id = "bingo.pizza"
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt})
        .to_return(read_http_fixture("purchaseLetsencryptCertificate/success.http"))

    attributes = { name: "www", auto_renew: true, alternate_names: ["api.example.com"] }
    @subject.purchase_letsencrypt_certificate(@account_id, domain_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_purchase_letsencrypt_certificate_returns_the_certificate_purchase
    domain_id = "bingo.pizza"
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt})
        .to_return(read_http_fixture("purchaseLetsencryptCertificate/success.http"))

    response = @subject.purchase_letsencrypt_certificate(@account_id, domain_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::CertificatePurchase, result)

    assert_equal(101967, result.id)
    assert_equal(101967, result.certificate_id)
    assert_equal("new", result.state)
    refute(result.auto_renew)
  end

  def test_purchase_letsencrypt_certificate_when_domain_does_not_exist_raises_not_found_error
    domain_id = "bingo.pizza"
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.purchase_letsencrypt_certificate(@account_id, domain_id)
    end
  end


  def test_issue_letsencrypt_certificate_builds_correct_request
    domain_id = "bingo.pizza"
    certificate_id = 101967
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/issue})
        .to_return(read_http_fixture("issueLetsencryptCertificate/success.http"))

    @subject.issue_letsencrypt_certificate(@account_id, domain_id, certificate_id)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/issue",
                     headers: { "Accept" => "application/json" })
  end

  def test_issue_letsencrypt_certificate_returns_the_certificate
    domain_id = "bingo.pizza"
    certificate_id = 101967
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/issue})
        .to_return(read_http_fixture("issueLetsencryptCertificate/success.http"))

    response = @subject.issue_letsencrypt_certificate(@account_id, domain_id, certificate_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Certificate, result)

    assert_equal(101967, result.id)
    assert_equal(289333, result.domain_id)
    assert_equal("www.bingo.pizza", result.common_name)
    assert_empty(result.alternate_names)
    assert_equal(1, result.years)
    assert_nil(result.csr)
    assert_equal("requesting", result.state)
    assert_equal("letsencrypt", result.authority_identifier)
    refute(result.auto_renew)
  end

  def test_issue_letsencrypt_certificate_when_domain_does_not_exist_raises_not_found_error
    domain_id = "bingo.pizza"
    certificate_id = 101967
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.issue_letsencrypt_certificate(@account_id, domain_id, certificate_id)
    end
  end

  def test_issue_letsencrypt_certificate_when_certificate_does_not_exist_raises_not_found_error
    domain_id = "bingo.pizza"
    certificate_id = 101967
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-certificate.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.issue_letsencrypt_certificate(@account_id, domain_id, certificate_id)
    end
  end


  def test_purchase_letsencrypt_certificate_renewal_builds_correct_request
    domain_id = "bingo.pizza"
    certificate_id = 101967
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals})
        .to_return(read_http_fixture("purchaseRenewalLetsencryptCertificate/success.http"))

    @subject.purchase_letsencrypt_certificate_renewal(@account_id, domain_id, certificate_id)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals",
                     headers: { "Accept" => "application/json" })
  end

  def test_purchase_letsencrypt_certificate_renewal_passes_extra_attributes
    domain_id = "bingo.pizza"
    certificate_id = 101967
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals})
        .to_return(read_http_fixture("purchaseRenewalLetsencryptCertificate/success.http"))

    attributes = { auto_renew: true }
    @subject.purchase_letsencrypt_certificate_renewal(@account_id, domain_id, certificate_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_purchase_letsencrypt_certificate_renewal_returns_the_certificate_renew
    domain_id = "bingo.pizza"
    certificate_id = 101967
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals})
        .to_return(read_http_fixture("purchaseRenewalLetsencryptCertificate/success.http"))

    response = @subject.purchase_letsencrypt_certificate_renewal(@account_id, domain_id, certificate_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::CertificateRenewal, result)

    assert_equal(65082, result.id)
    assert_equal(certificate_id, result.old_certificate_id)
    assert_equal(101972, result.new_certificate_id)
    assert_equal("new", result.state)
  end

  def test_purchase_letsencrypt_certificate_renewal_when_domain_does_not_exist_raises_not_found_error
    domain_id = "bingo.pizza"
    certificate_id = 101967
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.purchase_letsencrypt_certificate_renewal(@account_id, domain_id, certificate_id)
    end
  end


  def test_issue_letsencrypt_certificate_renewal_builds_correct_request
    domain_id = "bingo.pizza"
    certificate_id = 101972
    certificate_renewal_id = 65082
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals/#{certificate_renewal_id}/issue})
        .to_return(read_http_fixture("issueRenewalLetsencryptCertificate/success.http"))

    @subject.issue_letsencrypt_certificate_renewal(@account_id, domain_id, certificate_id, certificate_renewal_id)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals/#{certificate_renewal_id}/issue",
                     headers: { "Accept" => "application/json" })
  end

  def test_issue_letsencrypt_certificate_renewal_returns_the_certificate
    domain_id = "bingo.pizza"
    certificate_id = 101972
    certificate_renewal_id = 65082
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals/#{certificate_renewal_id}/issue})
        .to_return(read_http_fixture("issueRenewalLetsencryptCertificate/success.http"))

    response = @subject.issue_letsencrypt_certificate_renewal(@account_id, domain_id, certificate_id, certificate_renewal_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Certificate, result)

    assert_equal(101972, result.id)
    assert_equal(289333, result.domain_id)
    assert_equal("www.bingo.pizza", result.common_name)
    assert_empty(result.alternate_names)
    assert_equal(1, result.years)
    assert_nil(result.csr)
    assert_equal("requesting", result.state)
    assert_equal("letsencrypt", result.authority_identifier)
    refute(result.auto_renew)
  end

  def test_issue_letsencrypt_certificate_renewal_when_domain_does_not_exist_raises_not_found_error
    domain_id = "bingo.pizza"
    certificate_id = 101972
    certificate_renewal_id = 65082
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.issue_letsencrypt_certificate_renewal(@account_id, domain_id, certificate_id, certificate_renewal_id)
    end
  end

  def test_issue_letsencrypt_certificate_renewal_when_certificate_does_not_exist_raises_not_found_error
    domain_id = "bingo.pizza"
    certificate_id = 101972
    certificate_renewal_id = 65082
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-certificate.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.issue_letsencrypt_certificate_renewal(@account_id, domain_id, certificate_id, certificate_renewal_id)
    end
  end
end
