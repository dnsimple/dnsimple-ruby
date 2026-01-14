# frozen_string_literal: true

require "test_helper"

class DomainsTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains
    @account_id = 1010
  end


  def test_domains_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/domains})
        .to_return(read_http_fixture("listDomains/success.http"))

    @subject.domains(@account_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains",
                     headers: { "Accept" => "application/json" })
  end

  def test_domains_supports_pagination
    stub_request(:get, %r{/v2/#{@account_id}/domains})
        .to_return(read_http_fixture("listDomains/success.http"))

    @subject.domains(@account_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains?page=2")
  end

  def test_domains_supports_extra_request_options
    stub_request(:get, %r{/v2/#{@account_id}/domains})
        .to_return(read_http_fixture("listDomains/success.http"))

    @subject.domains(@account_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains?foo=bar")
  end

  def test_domains_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/domains})
        .to_return(read_http_fixture("listDomains/success.http"))

    @subject.domains(@account_id, sort: "expiration:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains?sort=expiration:asc")
  end

  def test_domains_supports_filtering
    stub_request(:get, %r{/v2/#{@account_id}/domains})
        .to_return(read_http_fixture("listDomains/success.http"))

    @subject.domains(@account_id, filter: { name_like: "example" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains?name_like=example")
  end

  def test_domains_returns_the_domains
    stub_request(:get, %r{/v2/#{@account_id}/domains})
        .to_return(read_http_fixture("listDomains/success.http"))

    response = @subject.domains(@account_id)

    assert_kind_of(Dnsimple::PaginatedResponse, response)
    assert_kind_of(Array, response.data)
    assert_equal(2, response.data.size)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::Domain, result)
      assert_kind_of(Integer, result.id)
    end
  end

  def test_domains_exposes_the_pagination_information
    stub_request(:get, %r{/v2/#{@account_id}/domains})
        .to_return(read_http_fixture("listDomains/success.http"))

    response = @subject.domains(@account_id)

    assert_respond_to(response, :page)
    assert_equal(1, response.page)
    assert_kind_of(Integer, response.per_page)
    assert_kind_of(Integer, response.total_entries)
    assert_kind_of(Integer, response.total_pages)
  end


  def test_all_domains_delegates_to_client_paginate
    stub_request(:get, %r{/v2/#{@account_id}/domains})
        .to_return(read_http_fixture("listDomains/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:domains, @account_id, { foo: "bar" }])
    @subject.stub(:paginate, mock) do
      @subject.all_domains(@account_id, { foo: "bar" })
    end
    mock.verify
  end

  def test_all_domains_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/domains})
        .to_return(read_http_fixture("listDomains/success.http"))

    @subject.all_domains(@account_id, sort: "expiration:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains?page=1&per_page=100&sort=expiration:asc")
  end

  def test_all_domains_supports_filtering
    stub_request(:get, %r{/v2/#{@account_id}/domains})
        .to_return(read_http_fixture("listDomains/success.http"))

    @subject.all_domains(@account_id, filter: { registrant_id: 99 })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains?page=1&per_page=100&registrant_id=99")
  end


  def test_create_domain_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/domains$})
        .to_return(read_http_fixture("createDomain/created.http"))

    attributes = { name: "example.com" }
    @subject.create_domain(@account_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_create_domain_returns_the_domain
    stub_request(:post, %r{/v2/#{@account_id}/domains$})
        .to_return(read_http_fixture("createDomain/created.http"))

    attributes = { name: "example.com" }
    response = @subject.create_domain(@account_id, attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Domain, result)
    assert_kind_of(Integer, result.id)
  end


  def test_domain_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/domains/.+$})
        .to_return(read_http_fixture("getDomain/success.http"))

    @subject.domain(@account_id, domain = "example-alpha.com")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain}",
                     headers: { "Accept" => "application/json" })
  end

  def test_domain_returns_the_domain
    stub_request(:get, %r{/v2/#{@account_id}/domains/.+$})
        .to_return(read_http_fixture("getDomain/success.http"))

    response = @subject.domain(@account_id, "example-alpha.com")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Domain, result)
    assert_equal(181984, result.id)
    assert_equal(1385, result.account_id)
    assert_equal(2715, result.registrant_id)
    assert_equal("example-alpha.com", result.name)
    assert_equal("registered", result.state)
    refute(result.auto_renew)
    refute(result.private_whois)
    assert_equal("2021-06-05T02:15:00Z", result.expires_at)
    assert_equal("2020-06-04T19:15:14Z", result.created_at)
    assert_equal("2020-06-04T19:15:21Z", result.updated_at)
  end

  def test_domain_when_domain_does_not_exist_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.domain(@account_id, "example.com")
    end
  end


  def test_delete_domain_builds_correct_request
    stub_request(:delete, %r{/v2/#{@account_id}/domains/.+$})
        .to_return(read_http_fixture("deleteDomain/success.http"))

    @subject.delete_domain(@account_id, domain = "example.com")

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain}",
                     headers: { "Accept" => "application/json" })
  end

  def test_delete_domain_returns_nothing
    stub_request(:delete, %r{/v2/#{@account_id}/domains/.+$})
        .to_return(read_http_fixture("deleteDomain/success.http"))

    response = @subject.delete_domain(@account_id, "example.com")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end

  def test_delete_domain_when_domain_does_not_exist_raises_not_found_error
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.delete_domain(@account_id, "example.com")
    end
  end
end
