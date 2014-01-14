require 'spec_helper'

describe DNSimple::User do
  describe ".me" do
    before do
      stub_request(:get, %r[/users/me]).
          to_return(read_fixture("users/me/success.http"))
    end

    it "builds the correct request" do
      described_class.me

      WebMock.should have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/users/me").
                     with(:headers => { 'Accept' => 'application/json' })
    end

    it "returns the user" do
      result = described_class.me

      expect(result).to be_a(described_class)
      expect(result.id).to eq(2)
      expect(result.email).to eq("example@example.com")
      expect(result.domain_count).to eq(2)
      expect(result.domain_limit).to eq(50)
      expect(result.login_count).to eq(2)
      expect(result.failed_login_count).to eq(0)
      expect(result.created_at).to eq("2013-11-08T17:20:58Z")
      expect(result.updated_at).to eq("2014-01-14T17:45:57Z")
    end
  end
end
