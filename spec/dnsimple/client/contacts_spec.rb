require 'spec_helper'

describe Dnsimple::Client, ".contacts" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").contacts }


  describe "#contacts" do
    before do
      stub_request(:get, %r[/v1/contacts$]).
          to_return(read_fixture("contacts/contacts/success.http"))
    end

    it "builds the correct request" do
      subject.contacts

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/contacts").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the contacts" do
      results = subject.contacts

      expect(results).to be_a(Array)
      expect(results.size).to eq(2)

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Contact)
        expect(result.id).to be_a(Fixnum)
      end
    end
  end

  describe "#create_contact" do
    before do
      stub_request(:post, %r[/v1/contacts$]).
          to_return(read_fixture("contacts/create_contact/created.http"))
    end

    let(:attributes) { { first_name: "Simone", last_name: "Carletti", address1: "", city: "Rome", state_province: "RM", postal_code: "00171", country: "IT", email_address: "", phone: "" } }

    it "builds the correct request" do
      subject.create_contact(attributes)

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/contacts").
                             with(body: { contact: attributes }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the contact" do
      result = subject.create_contact(attributes)

      expect(result).to be_a(Dnsimple::Struct::Contact)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe "#contact" do
    before do
      stub_request(:get, %r[/v1/contacts/.+$]).
          to_return(read_fixture("contacts/contact/success.http"))
    end

    it "builds the correct request" do
      subject.contact(1)

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/contacts/1").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the contact" do
      result = subject.contact(1)

      expect(result).to be_a(Dnsimple::Struct::Contact)
      expect(result.id).to eq(1)
      expect(result.label).to eq("Default")
      expect(result.first_name).to eq("Simone")
      expect(result.last_name).to eq("Carletti")
      expect(result.job_title).to eq("Underwater Programmer")
      expect(result.organization_name).to eq("DNSimple")
      expect(result.email_address).to eq("simone.carletti@dnsimple.com")
      expect(result.phone).to eq("+1 111 4567890")
      expect(result.fax).to eq("+1 222 4567890")
      expect(result.address1).to eq("Awesome Street")
      expect(result.address2).to eq("c/o Someone")
      expect(result.city).to eq("Rome")
      expect(result.state_province).to eq("RM")
      expect(result.postal_code).to eq("00171")
      expect(result.country).to eq("IT")
      expect(result.created_at).to eq("2014-01-15T22:08:07.390Z")
      expect(result.updated_at).to eq("2014-01-15T22:08:07.390Z")
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("contacts/notfound-contact.http"))

        expect {
          subject.contact(1)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#update_contact" do
    before do
      stub_request(:put, %r[/v1/contacts/.+$]).
          to_return(read_fixture("contacts/update_contact/success.http"))
    end

    it "builds the correct request" do
      subject.update(1, { label: "Updated" })

      expect(WebMock).to have_requested(:put, "https://api.zone/v1/contacts/1").
                         with(body: { contact: { label: "Updated" } }).
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the contact" do
      result = subject.update_contact(1, {})

      expect(result).to be_a(Dnsimple::Struct::Contact)
      expect(result.id).to be_a(Fixnum)
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:put, %r[/v1]).
            to_return(read_fixture("contacts/notfound-contact.http"))

        expect {
          subject.update_contact(1, {})
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_contact" do
    before do
      stub_request(:delete, %r[/v1/contacts/1$]).
          to_return(read_fixture("contacts/delete_contact/success.http"))
    end

    it "builds the correct request" do
      subject.delete_contact(1)

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/contacts/1").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.delete_contact(1)

      expect(result).to be_truthy
    end

    it "supports HTTP 204" do
      stub_request(:delete, %r[/v1]).
          to_return(read_fixture("contacts/delete_contact/success-204.http"))

      result = subject.delete_contact(1)

      expect(result).to be_truthy
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("contacts/notfound-contact.http"))

        expect {
          subject.delete_contact(1)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
