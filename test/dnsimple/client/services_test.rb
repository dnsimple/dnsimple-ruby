# frozen_string_literal: true

require "test_helper"

class ServicesTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").services
  end

  def test_list_services_builds_correct_request
    stub_request(:get, %r{/v2/services})
        .to_return(read_http_fixture("listServices/success.http"))

    @subject.list_services

    assert_requested(:get, "https://api.dnsimple.test/v2/services",
                     headers: { "Accept" => "application/json" })
  end

  def test_list_services_supports_pagination
    stub_request(:get, %r{/v2/services})
        .to_return(read_http_fixture("listServices/success.http"))

    @subject.services(page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/services?page=2")
  end

  def test_list_services_supports_extra_request_options
    stub_request(:get, %r{/v2/services})
        .to_return(read_http_fixture("listServices/success.http"))

    @subject.services(query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/services?foo=bar")
  end

  def test_list_services_supports_sorting
    stub_request(:get, %r{/v2/services})
        .to_return(read_http_fixture("listServices/success.http"))

    @subject.services(sort: "short_name:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/services?sort=short_name:asc")
  end

  def test_list_services_returns_the_list_of_available_services
    stub_request(:get, %r{/v2/services})
        .to_return(read_http_fixture("listServices/success.http"))

    response = @subject.list_services

    assert_kind_of(Dnsimple::CollectionResponse, response)

    response.data.each do |service|
      assert_kind_of(Dnsimple::Struct::Service, service)
      assert_kind_of(Integer, service.id)
      assert_kind_of(String, service.name)
      assert_kind_of(String, service.sid)
      assert_kind_of(String, service.description)

      service.settings.each do |setting|
        assert_kind_of(Dnsimple::Struct::Service::Setting, setting)
      end
    end
  end

  def test_all_services_delegates_to_paginate
    stub_request(:get, %r{/v2/services})
        .to_return(read_http_fixture("listServices/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:services, { foo: "bar" }])
    @subject.stub(:paginate, mock) do
      @subject.all_services(foo: "bar")
    end
    mock.verify
  end

  def test_all_services_supports_sorting
    stub_request(:get, %r{/v2/services})
        .to_return(read_http_fixture("listServices/success.http"))

    @subject.all_services(sort: "short_name:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/services?page=1&per_page=100&sort=short_name:asc")
  end

  def test_service_builds_correct_request
    stub_request(:get, %r{/v2/services/1$})
        .to_return(read_http_fixture("getService/success.http"))

    service_id = 1
    @subject.service(service_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/services/#{service_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_service_returns_the_service
    stub_request(:get, %r{/v2/services/1$})
        .to_return(read_http_fixture("getService/success.http"))

    service_id = 1
    response = @subject.service(service_id)

    assert_kind_of(Dnsimple::Response, response)

    service = response.data

    assert_kind_of(Dnsimple::Struct::Service, service)
    assert_equal(1, service.id)
    assert_equal("Service 1", service.name)
    assert_equal("service1", service.sid)
    assert_equal("First service example.", service.description)
    assert_nil(service.setup_description)
    assert(service.requires_setup)
    assert_nil(service.default_subdomain)

    settings = service.settings

    assert_kind_of(Array, settings)
    assert_equal(1, settings.size)
    assert_equal("username", settings[0].name)
  end
end
