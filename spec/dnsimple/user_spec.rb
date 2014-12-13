require 'spec_helper'

describe Dnsimple::User do
  describe ".me" do
    before do
      stub_request(:get, %r[/v1/user]).
          to_return(read_fixture("account/user/success.http"))
    end

    it "builds the correct request" do
      described_class.me

      expect(WebMock).to have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/user").
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

  describe ".two_factor_exchange_token" do
    before do
      stub_request(:get, %r[/v1/user]).
          to_return(read_fixture("2fa/exchange-token.http"))
    end

    let(:otp_token) { '1234567' }

    it "builds the correct request" do
      described_class.two_factor_exchange_token(otp_token)

      expect(WebMock).to have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/user").
        # workaround for https://github.com/bblimke/webmock/issues/276
        with { |req|
          # req.headers[Dnsimple::Client::HEADER_OTP_TOKEN] == otp_token
          req.headers["X-Dnsimple-Otp"] == otp_token
        }
    end

    it "returns the exchange_token" do
      result = described_class.two_factor_exchange_token(otp_token)

      expect(result).to eq("0c622716aaa64124219963075bc1c870")
    end

    context "when the OTP token is invalid" do
      before do
        stub_request(:get, %r[/v1/user]).
            to_return(read_fixture("2fa/error-badtoken.http"))
      end

      it "raises an AuthenticationFailed" do
        expect {
          described_class.two_factor_exchange_token("invalid-token")
        }.to raise_error(Dnsimple::AuthenticationFailed, "Bad OTP token")
      end
    end
  end
end
