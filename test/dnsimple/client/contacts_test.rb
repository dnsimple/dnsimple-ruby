# frozen_string_literal: true

require "test_helper"

class ContactsTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").contacts
    @account_id = 1010
  end

  def test_contacts_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    @subject.contacts(@account_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/contacts",
                     headers: { "Accept" => "application/json" })
  end

  def test_contacts_supports_pagination
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    @subject.contacts(@account_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/contacts?page=2")
  end

  def test_contacts_supports_extra_request_options
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    @subject.contacts(@account_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/contacts?foo=bar")
  end

  def test_contacts_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    @subject.contacts(@account_id, sort: "label:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/contacts?sort=label:desc")
  end

  def test_contacts_returns_the_contacts
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    response = @subject.contacts(@account_id)

    assert_kind_of(Dnsimple::PaginatedResponse, response)
    assert_kind_of(Array, response.data)
    assert_equal(2, response.data.size)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::Contact, result)
      assert_kind_of(Integer, result.id)
    end
  end

  def test_contacts_exposes_pagination_information
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    response = @subject.contacts(@account_id)

    assert_respond_to(response, :page)
    assert_equal(1, response.page)
    assert_kind_of(Integer, response.per_page)
    assert_kind_of(Integer, response.total_entries)
    assert_kind_of(Integer, response.total_pages)
  end

  def test_all_contacts_delegates_to_paginate
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:contacts, @account_id, { foo: "bar" }])
    @subject.stub(:paginate, mock) do
      @subject.all_contacts(@account_id, { foo: "bar" })
    end
    mock.verify
  end

  def test_all_contacts_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    @subject.all_contacts(@account_id, sort: "label:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/contacts?page=1&per_page=100&sort=label:desc")
  end

  def test_create_contact_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/contacts$})
        .to_return(read_http_fixture("createContact/created.http"))

    attributes = { first_name: "Simone", last_name: "Carletti", address1: "Italian Street", city: "Rome", state_province: "RM", postal_code: "00171", country: "IT", email: "example@example.com", phone: "+393391234567" }
    @subject.create_contact(@account_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/contacts",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_create_contact_returns_the_contact
    stub_request(:post, %r{/v2/#{@account_id}/contacts$})
        .to_return(read_http_fixture("createContact/created.http"))

    attributes = { first_name: "Simone", last_name: "Carletti", address1: "Italian Street", city: "Rome", state_province: "RM", postal_code: "00171", country: "IT", email: "example@example.com", phone: "+393391234567" }
    response = @subject.create_contact(@account_id, attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Contact, result)
    assert_kind_of(Integer, result.id)
  end

  def test_contact_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/contacts/.+$})
        .to_return(read_http_fixture("getContact/success.http"))

    contact = 1
    @subject.contact(@account_id, contact)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/contacts/#{contact}",
                     headers: { "Accept" => "application/json" })
  end

  def test_contact_returns_the_contact
    stub_request(:get, %r{/v2/#{@account_id}/contacts/.+$})
        .to_return(read_http_fixture("getContact/success.http"))

    response = @subject.contact(@account_id, 0)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Contact, result)
    assert_equal(1, result.id)
    assert_equal(1010, result.account_id)
    assert_equal("2016-01-19T20:50:26Z", result.created_at)
    assert_equal("2016-01-19T20:50:26Z", result.updated_at)
  end

  def test_contact_when_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-contact.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.contact(@account_id, 0)
    end
  end

  def test_update_contact_builds_correct_request
    stub_request(:patch, %r{/v2/#{@account_id}/contacts/.+$})
        .to_return(read_http_fixture("updateContact/success.http"))

    attributes = { first_name: "Updated" }
    contact_id = 1
    @subject.update_contact(@account_id, contact_id, attributes)

    assert_requested(:patch, "https://api.dnsimple.test/v2/#{@account_id}/contacts/#{contact_id}",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_update_contact_returns_the_contact
    stub_request(:patch, %r{/v2/#{@account_id}/contacts/.+$})
        .to_return(read_http_fixture("updateContact/success.http"))

    attributes = { first_name: "Updated" }
    response = @subject.update_contact(@account_id, 1, attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Contact, result)
    assert_equal(1, result.id)
  end

  def test_update_contact_when_not_found_raises_not_found_error
    stub_request(:patch, %r{/v2})
        .to_return(read_http_fixture("notfound-contact.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.update_contact(@account_id, 0, {})
    end
  end

  def test_delete_contact_builds_correct_request
    stub_request(:delete, %r{/v2/#{@account_id}/contacts/.+$})
        .to_return(read_http_fixture("deleteContact/success.http"))

    domain = "example.com"
    @subject.delete_contact(@account_id, domain)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/contacts/#{domain}",
                     headers: { "Accept" => "application/json" })
  end

  def test_delete_contact_returns_nothing
    stub_request(:delete, %r{/v2/#{@account_id}/contacts/.+$})
        .to_return(read_http_fixture("deleteContact/success.http"))

    response = @subject.delete_contact(@account_id, 1)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end

  def test_delete_contact_when_not_found_raises_not_found_error
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-contact.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.delete_contact(@account_id, 0)
    end
  end
end
