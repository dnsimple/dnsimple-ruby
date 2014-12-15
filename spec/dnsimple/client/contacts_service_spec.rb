require 'spec_helper'

describe Dnsimple::Client, ".contacts" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").contacts }


  describe "#list" do
    before do
      stub_request(:get, %r[/v1/contacts$]).
          to_return(read_fixture("contacts/index/success.http"))
    end

    it "builds the correct request" do
      subject.list

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/contacts").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the contacts" do
      results = subject.list

      expect(results).to be_a(Array)
      expect(results.size).to eq(1)

      result = results[0]
      expect(result.id).to eq(28)
    end
  end

  describe "#create" do
    before do
      stub_request(:post, %r[/v1/contacts]).
          to_return(read_fixture("contacts/create/created.http"))
    end

    let(:attributes) { { first_name: "Simone", last_name: "Carletti", address1: "", city: "Rome", state_province: "RM", postal_code: "00171", country: "IT", email_address: "", phone: "" } }

    it "builds the correct request" do
      subject.create(attributes)

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/contacts").
                         with(body: { contact: attributes }).
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the contact" do
      result = subject.create(attributes)

      expect(result).to be_a(Dnsimple::Contact)
      expect(result.id).to eq(22968)
    end
  end

  describe "#find" do
    before do
      stub_request(:get, %r[/v1/contacts/.+$]).
          to_return(read_fixture("contacts/show/success.http"))
    end

    it "builds the correct request" do
      subject.find(1)

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/contacts/1").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the contact" do
      result = subject.find(1)

      expect(result).to be_a(Dnsimple::Contact)
      expect(result.id).to eq(2)
      expect(result.label).to eq("Default")
      expect(result.first_name).to eq("Simone")
      expect(result.last_name).to eq("Carletti")
      expect(result.job_title).to eq("Underwater Programmer")
      expect(result.organization_name).to eq("Dnsimple")
      expect(result.email_address).to eq("example@example.com")
      expect(result.phone).to eq("+1 111 000000")
      expect(result.fax).to eq("+1 222 000000")
      expect(result.address1).to eq("Awesome Street")
      expect(result.address2).to eq("c/o Someone")
      expect(result.city).to eq("Rome")
      expect(result.state_province).to eq("RM")
      expect(result.postal_code).to eq("00171")
      expect(result.country).to eq("IT")
      expect(result.created_at).to eq("2013-11-08T17:23:15Z")
      expect(result.updated_at).to eq("2013-11-08T17:23:15Z")
    end
  end

  describe "#update" do
    before do
      stub_request(:put, %r[/v1/contacts/.+$]).
          to_return(read_fixture("contacts/update/success.http"))
    end

    it "builds the correct request" do
      subject.update(1, { label: "Updated" })

      expect(WebMock).to have_requested(:put, "https://api.zone/v1/contacts/1").
                         with(body: { contact: { label: "Updated" } }).
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the contact" do
      result = subject.update(1, {})

      expect(result).to be_a(Dnsimple::Contact)
      expect(result.id).to eq(22968)
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:put, %r[/v1]).
            to_return(read_fixture("contacts/notfound.http"))

        expect {
          subject.update(1, {})
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe "#delete" do
    before do
      stub_request(:delete, %r[/v1/contacts/1$]).
          to_return(read_fixture("contacts/delete/success.http"))
    end

    it "builds the correct request" do
      subject.delete(1)

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/contacts/1").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.delete(1)

      expect(result).to be_truthy
    end

    it "supports HTTP 204" do
      stub_request(:delete, %r[/v1]).
          to_return(read_fixture("contacts/delete/success-204.http"))

      result = subject.delete(1)

      expect(result).to be_truthy
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("records/notfound.http"))

        expect {
          subject.delete(1)
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

end
