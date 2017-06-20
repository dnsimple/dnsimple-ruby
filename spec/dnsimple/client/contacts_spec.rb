require 'spec_helper'

describe Dnsimple::Client, ".contacts" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").contacts }


  describe "#contacts" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/contacts})
          .to_return(read_http_fixture("listContacts/success.http"))
    end

    it "builds the correct request" do
      subject.contacts(account_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.contacts(account_id, page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts?page=2")
    end

    it "supports extra request options" do
      subject.contacts(account_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts?foo=bar")
    end

    it "supports sorting" do
      subject.contacts(account_id, sort: "label:desc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts?sort=label:desc")
    end

    it "returns the contacts" do
      response = subject.contacts(account_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Contact)
        expect(result.id).to be_a(Integer)
      end
    end

    it "exposes the pagination information" do
      response = subject.contacts(account_id)

      expect(response.respond_to?(:page)).to be_truthy
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Integer)
      expect(response.total_entries).to be_a(Integer)
      expect(response.total_pages).to be_a(Integer)
    end
  end

  describe "#all_contacts" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/contacts})
          .to_return(read_http_fixture("listContacts/success.http"))
    end

    let(:account_id) { 1010 }

    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:contacts, account_id, foo: "bar")
      subject.all_contacts(account_id, foo: "bar")
    end

    it "supports sorting" do
      subject.all_contacts(account_id, sort: "label:desc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts?page=1&per_page=100&sort=label:desc")
    end
  end

  describe "#create_contact" do
    let(:account_id) { 1010 }

    before do
      stub_request(:post, %r{/v2/#{account_id}/contacts$})
          .to_return(read_http_fixture("createContact/created.http"))
    end

    let(:attributes) { { first_name: "Simone", last_name: "Carletti", address1: "Italian Street", city: "Rome", state_province: "RM", postal_code: "00171", country: "IT", email: "example@example.com", phone: "+393391234567" } }

    it "builds the correct request" do
      subject.create_contact(account_id, attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/contacts")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the contact" do
      response = subject.create_contact(account_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Contact)
      expect(result.id).to be_a(Integer)
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

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts/#{contact}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the contact" do
      response = subject.contact(account_id, 0)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Contact)
      expect(result.id).to eq(1)
      expect(result.account_id).to eq(1010)
      expect(result.created_at).to eq("2016-01-19T20:50:26Z")
      expect(result.updated_at).to eq("2016-01-19T20:50:26Z")
    end

    context "when the contact does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-contact.http"))

        expect {
          subject.contact(account_id, 0)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#update_contact" do
    let(:account_id) { 1010 }

    before do
      stub_request(:patch, %r{/v2/#{account_id}/contacts/.+$})
          .to_return(read_http_fixture("updateContact/success.http"))
    end

    let(:attributes) { { first_name: "Updated" } }

    it "builds the correct request" do
      subject.update_contact(account_id, contact_id = 1, attributes)

      expect(WebMock).to have_requested(:patch, "https://api.dnsimple.test/v2/#{account_id}/contacts/#{contact_id}")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the contact" do
      response = subject.update_contact(account_id, 1, attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Contact)
      expect(result.id).to eq(1)
    end

    context "when the contact does not exist" do
      it "raises NotFoundError" do
        stub_request(:patch, %r{/v2})
            .to_return(read_http_fixture("notfound-contact.http"))

        expect {
          subject.update_contact(account_id, 0, {})
        }.to raise_error(Dnsimple::NotFoundError)
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

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/contacts/#{domain}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      response = subject.delete_contact(account_id, 1)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end

    context "when the contact does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-contact.http"))

        expect {
          subject.delete_contact(account_id, 0)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
