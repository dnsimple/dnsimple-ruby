require 'spec_helper'

describe Dnsimple::Client, ".users" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").users }


  describe "#user" do
    before do
      stub_request(:get, %r[/v1/user]).
          to_return(read_fixture("users/user/success.http"))
    end

    it "builds the correct request" do
      subject.user

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/user").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the user" do
      result = subject.user

      expect(result).to be_a(Dnsimple::User)
      expect(result.id).to eq(1)
      expect(result.email).to eq("example@example.com")
      expect(result.api_token).to eq("api-token")
      expect(result.domain_count).to eq(32)
      expect(result.domain_limit).to eq(1000)
      expect(result.login_count).to eq(2)
      expect(result.failed_login_count).to eq(1)
      expect(result.created_at).to eq("2011-03-17T21:30:25.731Z")
      expect(result.updated_at).to eq("2014-12-13T13:52:08.343Z")
    end
  end

  describe "#exchange_token" do
    before do
      stub_request(:get, %r[/v1/user]).
          to_return(read_fixture("2fa/exchange-token.http"))
    end

    it "builds the correct request" do
      subject.exchange_token("123456")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/user").
                         with(headers: { "X-Dnsimple-Otp" => "123456" })
    end

    it "returns the exchange_token" do
      result = subject.exchange_token("123456")

      expect(result).to eq("0c622716aaa64124219963075bc1c870")
    end

    context "when the OTP token is invalid" do
      before do
        stub_request(:get, %r[/v1/user]).
            to_return(read_fixture("2fa/error-badtoken.http"))
      end

      it "raises an AuthenticationFailed" do
        expect {
          subject.exchange_token("invalid-token")
        }.to raise_error(Dnsimple::AuthenticationFailed, "Bad OTP token")
      end
    end
  end

end
