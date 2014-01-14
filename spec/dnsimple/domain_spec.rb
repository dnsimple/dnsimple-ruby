require 'spec_helper'

describe DNSimple::Domain do

  let(:contact_id) { 1001 }

  describe ".find" do
    before do
      stub_request(:get, %r[/domains/example.com]).
          to_return(read_fixture("domains/show/success.http"))
    end

    it "builds the correct request" do
      described_class.find("example.com")

      WebMock.should have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/domains/example.com").
                     with(:headers => { 'Accept' => 'application/json' })
    end

    context "when the domain exists" do
      it "returns the domain" do
        result = described_class.find("example.com")

        expect(result).to be_a(described_class)
        expect(result.id).to eq(6)
        expect(result.name).to eq("test-1383931357.com")
        expect(result.created_at).to eq("2013-11-08T17:22:48Z")
        expect(result.updated_at).to eq("2014-01-14T18:27:04Z")

        expect(result.name_server_status).to be_nil
      end
    end
  end

end
