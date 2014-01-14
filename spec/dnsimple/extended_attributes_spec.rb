require 'spec_helper'

describe DNSimple::ExtendedAttribute do

  describe ".find" do
    before do
      stub_request(:get, %r[/extended_attributes/com]).
          to_return(read_fixture("extended_attributes/success.http"))
    end

    it "builds the correct request" do
      described_class.find("com")

      WebMock.should have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/extended_attributes/com").
                     with(:headers => { 'Accept' => 'application/json' })
    end

    context "when the TLD has no attributes" do
      before do
        stub_request(:get, %r[/extended_attributes/com]).
            to_return(read_fixture("extended_attributes/com.http"))
      end

      it "returns an empty list" do
        result = described_class.find("com")

        expect(result).to eq([])
      end
    end

    context "when the TLD has attributes" do
      before do
        stub_request(:get, %r[/extended_attributes/ca]).
            to_return(read_fixture("extended_attributes/ca.http"))
      end

      it "returns the attributes" do
        result = described_class.find("ca")

        expect(result).to be_a(Array)
        expect(result).to have(5).attributes

        attribute = result[0]
        expect(attribute).to be_a(described_class)
        expect(attribute.name).to eq("cira_legal_type")
        expect(attribute.description).to eq("Legal type of registrant contact")
        expect(attribute.required).to be_true
        expect(attribute.options).to be_a(Array)
        expect(attribute.options).to have(18).options
      end
    end
  end

end
