# frozen_string_literal: true

require "test_helper"

class ContactsTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").contacts
    @account_id = 1010
  end

  test "builds the correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    @subject.contacts(@account_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/contacts",
                     headers: { "Accept" => "application/json" })
  end

  test "supports pagination" do
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    @subject.contacts(@account_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/contacts?page=2")
  end

  test "supports extra request options" do
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    @subject.contacts(@account_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/contacts?foo=bar")
  end

  test "supports sorting" do
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    @subject.contacts(@account_id, sort: "label:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/contacts?sort=label:desc")
  end

  test "returns the contacts" do
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

  test "exposes the pagination information" do
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    response = @subject.contacts(@account_id)

    assert_respond_to(response, :page)
    assert_equal(1, response.page)
    assert_kind_of(Integer, response.per_page)
    assert_kind_of(Integer, response.total_entries)
    assert_kind_of(Integer, response.total_pages)
  end

  test "delegates to client.paginate" do
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:contacts, @account_id, { foo: "bar" }])
    @subject.stub(:paginate, mock) do
      @subject.all_contacts(@account_id, { foo: "bar" })
    end
    mock.verify
  end

  test "all_contacts supports sorting" do
    stub_request(:get, %r{/v2/#{@account_id}/contacts})
        .to_return(read_http_fixture("listContacts/success.http"))

    @subject.all_contacts(@account_id, sort: "label:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/contacts?page=1&per_page=100&sort=label:desc")
  end

  test "create_contact builds the correct request" do
    stub_request(:post, %r{/v2/#{@account_id}/contacts$})
        .to_return(read_http_fixture("createContact/created.http"))

    attributes = { first_name: "Simone", last_name: "Carletti", address1: "Italian Street", city: "Rome", state_province: "RM", postal_code: "00171", country: "IT", email: "example@example.com", phone: "+393391234567" }
    @subject.create_contact(@account_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/contacts",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  test "create_contact returns the contact" do
    stub_request(:post, %r{/v2/#{@account_id}/contacts$})
        .to_return(read_http_fixture("createContact/created.http"))

    attributes = { first_name: "Simone", last_name: "Carletti", address1: "Italian Street", city: "Rome", state_province: "RM", postal_code: "00171", country: "IT", email: "example@example.com", phone: "+393391234567" }
    response = @subject.create_contact(@account_id, attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Contact, result)
    assert_kind_of(Integer, result.id)
  end

  test "contact builds the correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/contacts/.+$})
        .to_return(read_http_fixture("getContact/success.http"))

    contact = 1
    @subject.contact(@account_id, contact)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/contacts/#{contact}",
                     headers: { "Accept" => "application/json" })
  end

  test "contact returns the contact" do
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

  test "contact raises NotFoundError when the contact does not exist" do
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-contact.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.contact(@account_id, 0)
    end
  end

  test "update_contact builds the correct request" do
    stub_request(:patch, %r{/v2/#{@account_id}/contacts/.+$})
        .to_return(read_http_fixture("updateContact/success.http"))

    attributes = { first_name: "Updated" }
    contact_id = 1
    @subject.update_contact(@account_id, contact_id, attributes)

    assert_requested(:patch, "https://api.dnsimple.test/v2/#{@account_id}/contacts/#{contact_id}",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  test "update_contact returns the contact" do
    stub_request(:patch, %r{/v2/#{@account_id}/contacts/.+$})
        .to_return(read_http_fixture("updateContact/success.http"))

    attributes = { first_name: "Updated" }
    response = @subject.update_contact(@account_id, 1, attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Contact, result)
    assert_equal(1, result.id)
  end

  test "update_contact raises NotFoundError when the contact does not exist" do
    stub_request(:patch, %r{/v2})
        .to_return(read_http_fixture("notfound-contact.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.update_contact(@account_id, 0, {})
    end
  end

  test "delete_contact builds the correct request" do
    stub_request(:delete, %r{/v2/#{@account_id}/contacts/.+$})
        .to_return(read_http_fixture("deleteContact/success.http"))

    domain = "example.com"
    @subject.delete_contact(@account_id, domain)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/contacts/#{domain}",
                     headers: { "Accept" => "application/json" })
  end

  test "delete_contact returns nothing" do
    stub_request(:delete, %r{/v2/#{@account_id}/contacts/.+$})
        .to_return(read_http_fixture("deleteContact/success.http"))

    response = @subject.delete_contact(@account_id, 1)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end

  test "delete_contact raises NotFoundError when the contact does not exist" do
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-contact.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.delete_contact(@account_id, 0)
    end
  end
end
