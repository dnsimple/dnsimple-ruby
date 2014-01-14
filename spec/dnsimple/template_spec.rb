require 'spec_helper'

describe DNSimple::Template do

  describe ".find" do
    before do
      stub_request(:get, %r[/v1/templates/google-apps]).
          to_return(read_fixture("templates/show/success.http"))
    end

    it "builds the correct request" do
      described_class.find("google-apps")

      WebMock.should have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/templates/google-apps").
                     with(:headers => { 'Accept' => 'application/json' })
    end

    context "when the template exists" do
      it "returns the template" do
        result = described_class.find("google-apps")

        expect(result).to be_a(described_class)
        expect(result.id).to eq(63)
        expect(result.name).to eq("Google Apps")
        expect(result.short_name).to eq("google-apps")
        expect(result.description).to eq("The Google Mail Servers and Google Apps CNAME records in a single template.")
      end
    end
  end

end
