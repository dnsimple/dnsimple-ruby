require 'spec_helper'

describe DNSimple::User do
  describe ".me" do
    before do
      stub_request(:get, %r[/v1/user]).
          to_return(read_fixture("account/user/success.http"))
    end

    it "builds the correct request" do
      described_class.me

      WebMock.should have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/user").
                     with(:headers => { 'Accept' => 'application/json' })
    end

    it "returns the user" do
      result = described_class.me

      expect(result).to be_a(described_class)
      expect(result.id).to eq(19)
      expect(result.email).to eq("example@example.com")
      expect(result.domain_count).to be_a(Integer)
      expect(result.domain_limit).to be_a(Integer)
      expect(result.login_count).to be_a(Integer)
      expect(result.failed_login_count).to be_a(Integer)
      expect(result.created_at).to eq("2014-01-15T21:59:04Z")
      expect(result.updated_at).to be_a(String)
    end
  end
end
