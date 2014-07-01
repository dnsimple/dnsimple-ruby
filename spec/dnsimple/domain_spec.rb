require 'spec_helper'

describe DNSimple::Domain do

  let(:contact_id) { 1001 }

  describe ".find" do
    before do
      stub_request(:get, %r[/v1/domains/example.com]).
          to_return(read_fixture("domains/show/success.http"))
    end

    it "builds the correct request" do
      described_class.find("example.com")

      expect(WebMock).to have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/domains/example.com").
          with(:headers => { 'Accept' => 'application/json' })
    end

    context "when the domain exists" do
      it "returns the domain" do
        result = described_class.find("example.com")

        expect(result).to be_a(described_class)
        expect(result.id).to eq(6)
        expect(result.name).to eq("test-1383931357.com")
        expect(result.expires_on).to eq('2015-11-08')
        expect(result.created_at).to eq("2013-11-08T17:22:48Z")
        expect(result.updated_at).to eq("2014-01-14T18:27:04Z")
        expect(result.state).to eq("registered")
        expect(result.registrant_id).to eq(2)
        expect(result.user_id).to eq(2)
        expect(result.lockable).to eq(true)
        expect(result.auto_renew).to eq(true)
        expect(result.whois_protected).to eq(false)

        expect(result.name_server_status).to be_nil
      end
    end
  end

end
