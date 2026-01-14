# frozen_string_literal: true

require "test_helper"

class DomainsEmailForwardsTest < Minitest::Test

  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains
    @account_id = 1010
    @domain_id = "example.com"
  end

  def test_email_forwards_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards})
        .to_return(read_http_fixture("listEmailForwards/success.http"))

    @subject.email_forwards(@account_id, @domain_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/email_forwards",
                     headers: { "Accept" => "application/json" })
  end

  def test_email_forwards_supports_pagination
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards})
        .to_return(read_http_fixture("listEmailForwards/success.http"))

    @subject.email_forwards(@account_id, @domain_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/email_forwards?page=2")
  end

  def test_email_forwards_supports_extra_request_options
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards})
        .to_return(read_http_fixture("listEmailForwards/success.http"))

    @subject.email_forwards(@account_id, @domain_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/email_forwards?foo=bar")
  end

  def test_email_forwards_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards})
        .to_return(read_http_fixture("listEmailForwards/success.http"))

    @subject.email_forwards(@account_id, @domain_id, sort: "id:asc,from:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/email_forwards?sort=id:asc,from:desc")
  end

  def test_email_forwards_returns_the_email_forwards
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards})
        .to_return(read_http_fixture("listEmailForwards/success.http"))

    response = @subject.email_forwards(@account_id, @domain_id)

    assert_kind_of(Dnsimple::PaginatedResponse, response)
    assert_kind_of(Array, response.data)
    assert_equal(1, response.data.size)

    assert_equal(24809, response.data[0].id)
    assert_equal(235146, response.data[0].domain_id)
    assert_equal(".*@a-domain.com", response.data[0].alias_email)
    assert_equal("jane.smith@example.com", response.data[0].destination_email)
    assert_equal(true, response.data[0].active)
  end

  def test_email_forwards_exposes_pagination_information
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards})
        .to_return(read_http_fixture("listEmailForwards/success.http"))

    response = @subject.email_forwards(@account_id, @domain_id)

    assert_respond_to(response, :page)
    assert_equal(1, response.page)
    assert_kind_of(Integer, response.per_page)
    assert_kind_of(Integer, response.total_entries)
    assert_kind_of(Integer, response.total_pages)
  end

  def test_email_forwards_when_domain_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-domain.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.email_forwards(@account_id, @domain_id)
    end
  end

  def test_all_email_forwards_delegates_to_paginate
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards})
        .to_return(read_http_fixture("listEmailForwards/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:email_forwards, @account_id, @domain_id, { foo: "bar" }])
    @subject.stub(:paginate, mock) do
      @subject.all_email_forwards(@account_id, @domain_id, { foo: "bar" })
    end
    mock.verify
  end

  def test_all_email_forwards_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards})
        .to_return(read_http_fixture("listEmailForwards/success.http"))

    @subject.all_email_forwards(@account_id, @domain_id, sort: "id:asc,from:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/email_forwards?page=1&per_page=100&sort=id:asc,from:desc")
  end

  def test_create_email_forward_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards$})
        .to_return(read_http_fixture("createEmailForward/created.http"))

    attributes = { alias_name: "jim", destination_email: "jim@another.com" }
    @subject.create_email_forward(@account_id, @domain_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/email_forwards",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_create_email_forward_returns_the_email_forward
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards$})
        .to_return(read_http_fixture("createEmailForward/created.http"))

    attributes = { alias_name: "jim", destination_email: "jim@another.com" }
    response = @subject.create_email_forward(@account_id, @domain_id, attributes)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::EmailForward, result)
    assert_kind_of(Integer, result.id)
  end

  def test_email_forward_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards.+$})
        .to_return(read_http_fixture("getEmailForward/success.http"))

    email_forward_id = 41872
    @subject.email_forward(@account_id, @domain_id, email_forward_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/email_forwards/#{email_forward_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_email_forward_returns_the_email_forward
    stub_request(:get, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards.+$})
        .to_return(read_http_fixture("getEmailForward/success.http"))

    email_forward_id = 41872
    response = @subject.email_forward(@account_id, @domain_id, email_forward_id)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::EmailForward, result)
    assert_equal(41872, result.id)
    assert_equal(235146, result.domain_id)
    assert_equal("example@dnsimple.xyz", result.alias_email)
    assert_equal("example@example.com", result.destination_email)
    assert_equal("2021-01-25T13:54:40Z", result.created_at)
    assert_equal("2021-01-25T13:54:40Z", result.updated_at)
  end

  def test_email_forward_when_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-emailforward.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.email_forward(@account_id, @domain_id, 41872)
    end
  end

  def test_delete_email_forward_builds_correct_request
    stub_request(:delete, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards/1$})
        .to_return(read_http_fixture("deleteEmailForward/success.http"))

    email_forward_id = 1
    @subject.delete_email_forward(@account_id, @domain_id, email_forward_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/email_forwards/#{email_forward_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_delete_email_forward_returns_nothing
    stub_request(:delete, %r{/v2/#{@account_id}/domains/#{@domain_id}/email_forwards/1$})
        .to_return(read_http_fixture("deleteEmailForward/success.http"))

    email_forward_id = 1
    response = @subject.delete_email_forward(@account_id, @domain_id, email_forward_id)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_nil(result)
  end

  def test_delete_email_forward_when_not_found_raises_not_found_error
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-emailforward.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.delete_email_forward(@account_id, @domain_id, 1)
    end
  end

end
