# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".contacts" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").contacts }


  describe "#contacts" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/contacts})
          .to_return(read_http_fixture("listContacts/success.http"))
    end

    it "builds the correct request" do
      subject.contacts(account_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts",
                       headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.contacts(account_id, page: 2)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts?page=2")
    end

    it "supports extra request options" do
      subject.contacts(account_id, query: { foo: "bar" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts?foo=bar")
    end

    it "supports sorting" do
      subject.contacts(account_id, sort: "label:desc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts?sort=label:desc")
    end

    it "returns the contacts" do
      response = subject.contacts(account_id)

      _(response).must_be_kind_of(Dnsimple::PaginatedResponse)
      _(response.data).must_be_kind_of(Array)
      _(response.data.size).must_equal(2)

      response.data.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::Contact)
        _(result.id).must_be_kind_of(Integer)
      end
    end

    it "exposes the pagination information" do
      response = subject.contacts(account_id)

      _(response).must_respond_to(:page)
      _(response.page).must_equal(1)
      _(response.per_page).must_be_kind_of(Integer)
      _(response.total_entries).must_be_kind_of(Integer)
      _(response.total_pages).must_be_kind_of(Integer)
    end
  end

  describe "#all_contacts" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/contacts})
          .to_return(read_http_fixture("listContacts/success.http"))
    end

    let(:account_id) { 1010 }

    it "delegates to client.paginate" do
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [:contacts, account_id, { foo: "bar" }])
      subject.stub(:paginate, mock) do
        subject.all_contacts(account_id, { foo: "bar" })
      end
      mock.verify
    end

    it "supports sorting" do
      subject.all_contacts(account_id, sort: "label:desc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts?page=1&per_page=100&sort=label:desc")
    end
  end

  describe "#create_contact" do
    let(:account_id) { 1010 }
    let(:attributes) { { first_name: "Simone", last_name: "Carletti", address1: "Italian Street", city: "Rome", state_province: "RM", postal_code: "00171", country: "IT", email: "example@example.com", phone: "+393391234567" } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/contacts$})
          .to_return(read_http_fixture("createContact/created.http"))
    end


    it "builds the correct request" do
      subject.create_contact(account_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/contacts",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the contact" do
      response = subject.create_contact(account_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Contact)
      _(result.id).must_be_kind_of(Integer)
    end
  end

  describe "#contact" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/contacts/.+$})
          .to_return(read_http_fixture("getContact/success.http"))
    end

    it "builds the correct request" do
      subject.contact(account_id, contact = 1)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts/#{contact}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the contact" do
      response = subject.contact(account_id, 0)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Contact)
      _(result.id).must_equal(1)
      _(result.account_id).must_equal(1010)
      _(result.created_at).must_equal("2016-01-19T20:50:26Z")
      _(result.updated_at).must_equal("2016-01-19T20:50:26Z")
    end

    describe "when the contact does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-contact.http"))

        _ {
          subject.contact(account_id, 0)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#update_contact" do
    let(:account_id) { 1010 }
    let(:attributes) { { first_name: "Updated" } }

    before do
      stub_request(:patch, %r{/v2/#{account_id}/contacts/.+$})
          .to_return(read_http_fixture("updateContact/success.http"))
    end


    it "builds the correct request" do
      subject.update_contact(account_id, contact_id = 1, attributes)

      assert_requested(:patch, "https://api.dnsimple.test/v2/#{account_id}/contacts/#{contact_id}",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the contact" do
      response = subject.update_contact(account_id, 1, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Contact)
      _(result.id).must_equal(1)
    end

    describe "when the contact does not exist" do
      it "raises NotFoundError" do
        stub_request(:patch, %r{/v2})
            .to_return(read_http_fixture("notfound-contact.http"))

        _ {
          subject.update_contact(account_id, 0, {})
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_contact" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/contacts/.+$})
          .to_return(read_http_fixture("deleteContact/success.http"))
    end

    it "builds the correct request" do
      subject.delete_contact(account_id, domain = "example.com")

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/contacts/#{domain}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.delete_contact(account_id, 1)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end

    describe "when the contact does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-contact.http"))

        _ {
          subject.delete_contact(account_id, 0)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

end
