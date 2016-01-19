require 'spec_helper'

describe Dnsimple::Client, ".contacts" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").contacts }


  describe "#contacts" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r[/v2/#{account_id}/contacts])
          .to_return(read_http_fixture("listContacts/success.http"))
    end

    it "builds the correct request" do
      subject.contacts(account_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.contacts(account_id, query: { page: 2 })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts?page=2")
    end

    it "supports extra request options" do
      subject.contacts(account_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/contacts?foo=bar")
    end

    it "returns the contacts" do
      response = subject.contacts(account_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Contact)
        expect(result.id).to be_a(Fixnum)
      end
    end

    it "exposes the pagination information" do
      response = subject.contacts(account_id)

      expect(response.respond_to?(:page)).to be_truthy
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Fixnum)
      expect(response.total_entries).to be_a(Fixnum)
      expect(response.total_pages).to be_a(Fixnum)
    end
  end

  describe "#all_contacts" do
    let(:account_id) { 1010 }

    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:contacts, account_id, { foo: "bar" })
      subject.all_contacts(account_id, { foo: "bar" })
    end
  end

  describe "#create_contact" do
    let(:account_id) { 1010 }

    before do
      stub_request(:post, %r[/v2/#{account_id}/contacts$])
          .to_return(read_http_fixture("createContact/created.http"))
    end

    let(:attributes) { { first_name: "Simone", last_name: "Carletti", address1: "Italian Street", city: "Rome", state_province: "RM", postal_code: "00171", country: "IT", email_address: "example@example.com", phone: "+393391234567" } }

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
      expect(result.id).to be_a(Fixnum)
    end
  end

end
