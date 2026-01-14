# frozen_string_literal: true

require "test_helper"

class ServicesDomainsTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").services
    @account_id = 1010
    @domain_id = "example.com"
    @service_id = "service1"
  end

  def test_applied_services_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/services})
        .to_return(read_http_fixture("appliedServices/success.http"))

    @subject.applied_services(@account_id, @domain_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/services",
                     headers: { "Accept" => "application/json" })
  end

  def test_applied_services_supports_pagination
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/services})
        .to_return(read_http_fixture("appliedServices/success.http"))

    @subject.applied_services(@account_id, @domain_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/services?page=2")
  end

  def test_applied_services_supports_extra_request_options
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/services})
        .to_return(read_http_fixture("appliedServices/success.http"))

    @subject.applied_services(@account_id, @domain_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/services?foo=bar")
  end

  def test_applied_services_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/services})
        .to_return(read_http_fixture("appliedServices/success.http"))

    @subject.applied_services(@account_id, @domain_id, sort: "short_name:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/services?sort=short_name:asc")
  end

  def test_applied_services_returns_the_list_of_available_services
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/services})
        .to_return(read_http_fixture("appliedServices/success.http"))

    response = @subject.applied_services(@account_id, @domain_id)

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

  def test_apply_service_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/services/#{@service_id}$})
        .to_return(read_http_fixture("applyService/success.http"))

    settings = { app: "foo" }
    @subject.apply_service(@account_id, @service_id, @domain_id, settings)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/services/#{@service_id}",
                     body: settings,
                     headers: { "Accept" => "application/json" })
  end

  def test_apply_service_returns_empty_response
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/services/#{@service_id}$})
        .to_return(read_http_fixture("applyService/success.http"))

    settings = { app: "foo" }
    response = @subject.apply_service(@account_id, @service_id, @domain_id, settings)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end

  def test_unapply_service_builds_correct_request
    stub_request(:delete, %r{/v2/#{@account_id}/domains/#{@domain_id}/services/#{@service_id}$})
        .to_return(read_http_fixture("unapplyService/success.http"))

    @subject.unapply_service(@account_id, @service_id, @domain_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/services/#{@service_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_unapply_service_returns_empty_response
    stub_request(:delete, %r{/v2/#{@account_id}/domains/#{@domain_id}/services/#{@service_id}$})
        .to_return(read_http_fixture("unapplyService/success.http"))

    response = @subject.unapply_service(@account_id, @service_id, @domain_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end
end
