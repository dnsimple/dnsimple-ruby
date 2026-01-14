# frozen_string_literal: true

require "test_helper"

class TldsTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").tlds
  end

  def test_list_tlds_builds_correct_request
    stub_request(:get, %r{/v2/tlds})
        .to_return(read_http_fixture("listTlds/success.http"))

    @subject.list_tlds

    assert_requested(:get, "https://api.dnsimple.test/v2/tlds",
                     headers: { "Accept" => "application/json" })
  end

  def test_list_tlds_supports_pagination
    stub_request(:get, %r{/v2/tlds})
        .to_return(read_http_fixture("listTlds/success.http"))

    @subject.list_tlds(page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/tlds?page=2")
  end

  def test_list_tlds_supports_additional_options
    stub_request(:get, %r{/v2/tlds})
        .to_return(read_http_fixture("listTlds/success.http"))

    @subject.list_tlds(query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/tlds?foo=bar")
  end

  def test_list_tlds_supports_sorting
    stub_request(:get, %r{/v2/tlds})
        .to_return(read_http_fixture("listTlds/success.http"))

    @subject.list_tlds(sort: "tld:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/tlds?sort=tld:asc")
  end

  def test_list_tlds_returns_the_tlds
    stub_request(:get, %r{/v2/tlds})
        .to_return(read_http_fixture("listTlds/success.http"))

    response = @subject.list_tlds

    assert_kind_of(Dnsimple::PaginatedResponse, response)
    assert_kind_of(Array, response.data)
    assert_equal(2, response.data.size)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::Tld, result)
      assert_kind_of(Integer, result.tld_type)
      assert_kind_of(String, result.tld)
    end
  end

  def test_list_tlds_exposes_pagination_information
    stub_request(:get, %r{/v2/tlds})
        .to_return(read_http_fixture("listTlds/success.http"))

    response = @subject.list_tlds

    assert_respond_to(response, :page)
    assert_equal(1, response.page)
    assert_kind_of(Integer, response.per_page)
    assert_kind_of(Integer, response.total_entries)
    assert_kind_of(Integer, response.total_pages)
  end

  def test_all_tlds_delegates_to_paginate
    stub_request(:get, %r{/v2/tlds})
        .to_return(read_http_fixture("listTlds/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:list_tlds, { foo: "bar" }])
    @subject.stub(:paginate, mock) do
      @subject.all_tlds(foo: "bar")
    end
    mock.verify
  end

  def test_all_tlds_supports_sorting
    stub_request(:get, %r{/v2/tlds})
        .to_return(read_http_fixture("listTlds/success.http"))

    @subject.all_tlds(sort: "tld:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/tlds?page=1&per_page=100&sort=tld:asc")
  end

  def test_tld_builds_correct_request
    stub_request(:get, %r{/v2/tlds/.+$})
        .to_return(read_http_fixture("getTld/success.http"))

    tld = "com"
    @subject.tld(tld)

    assert_requested(:get, "https://api.dnsimple.test/v2/tlds/#{tld}",
                     headers: { "Accept" => "application/json" })
  end

  def test_tld_returns_the_tld
    stub_request(:get, %r{/v2/tlds/.+$})
        .to_return(read_http_fixture("getTld/success.http"))

    response = @subject.tld("com")

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Tld, result)
    assert_equal("com", result.tld)
    assert_equal(1, result.tld_type)
    assert(result.whois_privacy)
    refute(result.auto_renew_only)
    assert(result.idn)
    assert_equal(1, result.minimum_registration)
    assert(result.registration_enabled)
    assert(result.renewal_enabled)
    assert(result.transfer_enabled)
    assert_equal("ds", result.dnssec_interface_type)
  end

  def test_tld_extended_attributes_builds_correct_request
    stub_request(:get, %r{/v2/tlds/uk/extended_attributes$})
        .to_return(read_http_fixture("getTldExtendedAttributes/success.http"))

    tld = "uk"
    @subject.tld_extended_attributes(tld)

    assert_requested(:get, "https://api.dnsimple.test/v2/tlds/#{tld}/extended_attributes",
                     headers: { "Accept" => "application/json" })
  end

  def test_tld_extended_attributes_returns_the_extended_attributes
    stub_request(:get, %r{/v2/tlds/uk/extended_attributes$})
        .to_return(read_http_fixture("getTldExtendedAttributes/success.http"))

    response = @subject.tld_extended_attributes("uk")

    assert_kind_of(Dnsimple::CollectionResponse, response)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::ExtendedAttribute, result)
      assert_kind_of(String, result.name)
      assert_kind_of(String, result.description)
      assert_respond_to(result, :required)

      next if result.options.empty?

      result.options.each do |option|
        assert_kind_of(Dnsimple::Struct::ExtendedAttribute::Option, option)
        assert_kind_of(String, option.title)
        assert_kind_of(String, option.value)
        assert_kind_of(String, option.description)
      end
    end
  end

  def test_tld_extended_attributes_when_no_attributes_returns_empty_collection
    stub_request(:get, %r{/v2/tlds/com/extended_attributes$})
        .to_return(read_http_fixture("getTldExtendedAttributes/success-noattributes.http"))

    response = @subject.tld_extended_attributes("com")

    assert_kind_of(Dnsimple::CollectionResponse, response)

    result = response.data

    assert_empty(result)
  end
end
