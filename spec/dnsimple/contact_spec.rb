require 'spec_helper'

describe DNSimple::Contact do

  describe ".find" do
    before do
      stub_request(:get, %r[/contacts/2]).
          to_return(read_fixture("contacts/show/success.http"))
    end

    it "builds the correct request" do
      described_class.find("2")

      WebMock.should have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@api.sandbox.dnsimple.com/contacts/2").
                     with(:headers => { 'Accept' => 'application/json' })
    end

    context "when the contact exists" do
      it "returns the contact" do
        result = described_class.find("2")

        expect(result).to be_a(described_class)
        expect(result.id).to eq(2)
        expect(result.first_name).to eq("Simone")
        expect(result.last_name).to eq("Carletti")
        expect(result.job_title).to eq("Underwater Programmer")
        expect(result.organization_name).to eq("DNSimple")
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

        expect(result.phone_ext).to be_nil
      end
    end
  end

end
