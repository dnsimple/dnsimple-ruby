# frozen_string_literal: true

require "test_helper"

class DomainsPushesTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains
    @account_id = 1010
    @domain_id = "example.com"
  end

  test "initiate push builds correct request" do
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/pushes$})
        .to_return(read_http_fixture("initiatePush/success.http"))

    attributes = { new_account_email: "admin@target-account.test" }
    @subject.initiate_push(@account_id, @domain_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/pushes",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  test "initiate push returns the domain push" do
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/pushes$})
        .to_return(read_http_fixture("initiatePush/success.http"))

    attributes = { new_account_email: "admin@target-account.test" }
    response = @subject.initiate_push(@account_id, @domain_id, attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::DomainPush, result)
    assert_kind_of(Integer, result.id)
  end

  test "pushes builds correct request" do
    stub_request(:get, %r{/v2/2020/pushes})
        .to_return(read_http_fixture("listPushes/success.http"))

    account_id = 2020
    @subject.pushes(account_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/pushes",
                     headers: { "Accept" => "application/json" })
  end

  test "pushes supports pagination" do
    stub_request(:get, %r{/v2/2020/pushes})
        .to_return(read_http_fixture("listPushes/success.http"))

    account_id = 2020
    @subject.pushes(account_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/pushes?page=2")
  end

  test "pushes supports extra request options" do
    stub_request(:get, %r{/v2/2020/pushes})
        .to_return(read_http_fixture("listPushes/success.http"))

    account_id = 2020
    @subject.pushes(account_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/pushes?foo=bar")
  end

  test "pushes returns list of domain pushes" do
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

  test "pushes exposes pagination information" do
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

  test "accept push builds correct request" do
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

  test "accept push returns nothing" do
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

  test "accept push when not found raises not found error" do
    stub_request(:post, %r{/v2})
        .to_return(read_http_fixture("notfound-domainpush.http"))

    account_id = 2020
    push_id = 1
    attributes = { contact_id: 2 }
    assert_raises(Dnsimple::NotFoundError) do
      @subject.accept_push(account_id, push_id, attributes)
    end
  end

  test "reject push builds correct request" do
    stub_request(:delete, %r{/v2/2020/pushes/1$})
        .to_return(read_http_fixture("rejectPush/success.http"))

    account_id = 2020
    push_id = 1
    @subject.reject_push(account_id, push_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/pushes/#{push_id}",
                     headers: { "Accept" => "application/json" })
  end

  test "reject push returns nothing" do
    stub_request(:delete, %r{/v2/2020/pushes/1$})
        .to_return(read_http_fixture("rejectPush/success.http"))

    account_id = 2020
    push_id = 1
    response = @subject.reject_push(account_id, push_id)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end

  test "reject push when not found raises not found error" do
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-domainpush.http"))

    account_id = 2020
    push_id = 1
    assert_raises(Dnsimple::NotFoundError) do
      @subject.reject_push(account_id, push_id)
    end
  end
end
