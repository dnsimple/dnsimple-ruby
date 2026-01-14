# frozen_string_literal: true

require "test_helper"

class DomainsPushesTest < Minitest::Test

  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains
    @account_id = 1010
    @domain_id = "example.com"
  end

  def test_initiate_push_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/pushes$})
        .to_return(read_http_fixture("initiatePush/success.http"))

    attributes = { new_account_email: "admin@target-account.test" }
    @subject.initiate_push(@account_id, @domain_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/pushes",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_initiate_push_returns_the_domain_push
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/pushes$})
        .to_return(read_http_fixture("initiatePush/success.http"))

    attributes = { new_account_email: "admin@target-account.test" }
    response = @subject.initiate_push(@account_id, @domain_id, attributes)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::DomainPush, result)
    assert_kind_of(Integer, result.id)
  end

  def test_pushes_builds_correct_request
    stub_request(:get, %r{/v2/2020/pushes})
        .to_return(read_http_fixture("listPushes/success.http"))

    account_id = 2020
    @subject.pushes(account_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/pushes",
                     headers: { "Accept" => "application/json" })
  end

  def test_pushes_supports_pagination
    stub_request(:get, %r{/v2/2020/pushes})
        .to_return(read_http_fixture("listPushes/success.http"))

    account_id = 2020
    @subject.pushes(account_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/pushes?page=2")
  end

  def test_pushes_supports_extra_request_options
    stub_request(:get, %r{/v2/2020/pushes})
        .to_return(read_http_fixture("listPushes/success.http"))

    account_id = 2020
    @subject.pushes(account_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/pushes?foo=bar")
  end

  def test_pushes_returns_list_of_domain_pushes
    stub_request(:get, %r{/v2/2020/pushes})
        .to_return(read_http_fixture("listPushes/success.http"))

    account_id = 2020
    response = @subject.pushes(account_id)

    assert_kind_of(Dnsimple::PaginatedResponse, response)
    assert_kind_of(Array, response.data)
    assert_equal(2, response.data.size)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::DomainPush, result)
      assert_kind_of(Integer, result.id)
    end
  end

  def test_pushes_exposes_pagination_information
    stub_request(:get, %r{/v2/2020/pushes})
        .to_return(read_http_fixture("listPushes/success.http"))

    account_id = 2020
    response = @subject.pushes(account_id)

    assert_respond_to(response, :page)
    assert_equal(1, response.page)
    assert_kind_of(Integer, response.per_page)
    assert_kind_of(Integer, response.total_entries)
    assert_kind_of(Integer, response.total_pages)
  end

  def test_accept_push_builds_correct_request
    stub_request(:post, %r{/v2/2020/pushes/1$})
        .to_return(read_http_fixture("acceptPush/success.http"))

    account_id = 2020
    push_id = 1
    attributes = { contact_id: 2 }
    @subject.accept_push(account_id, push_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/pushes/#{push_id}",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_accept_push_returns_nothing
    stub_request(:post, %r{/v2/2020/pushes/1$})
        .to_return(read_http_fixture("acceptPush/success.http"))

    account_id = 2020
    push_id = 1
    attributes = { contact_id: 2 }
    response = @subject.accept_push(account_id, push_id, attributes)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_nil(result)
  end

  def test_accept_push_when_not_found_raises_not_found_error
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-domainpush.http"))

    account_id = 2020
    push_id = 1
    attributes = { contact_id: 2 }
    assert_raises(Dnsimple::NotFoundError) do
      @subject.accept_push(account_id, push_id, attributes)
    end
  end

  def test_reject_push_builds_correct_request
    stub_request(:delete, %r{/v2/2020/pushes/1$})
        .to_return(read_http_fixture("rejectPush/success.http"))

    account_id = 2020
    push_id = 1
    @subject.reject_push(account_id, push_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/pushes/#{push_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_reject_push_returns_nothing
    stub_request(:delete, %r{/v2/2020/pushes/1$})
        .to_return(read_http_fixture("rejectPush/success.http"))

    account_id = 2020
    push_id = 1
    response = @subject.reject_push(account_id, push_id)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_nil(result)
  end

  def test_reject_push_when_not_found_raises_not_found_error
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-domainpush.http"))

    account_id = 2020
    push_id = 1
    assert_raises(Dnsimple::NotFoundError) do
      @subject.reject_push(account_id, push_id)
    end
  end

end
