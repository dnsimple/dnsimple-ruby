require 'spec_helper'

describe Dnsimple::Client, ".registrar" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar }


  describe "#check" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r[/v2/#{account_id}/registrar/domains/.+/check$])
          .to_return(read_http_fixture("checkDomain/success.http"))
    end

    it "builds the correct request" do
      subject.check(account_id, domain_name = "example.com")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/check")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the availability" do
      response = subject.check(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DomainCheck)
      expect(result.domain).to eq("example.com")
      expect(result.available).to be_truthy
      expect(result.premium).to be_falsey
    end
  end

  describe "#register" do
    let(:account_id) { 1010 }

    before do
      stub_request(:post, %r[/v2/#{account_id}/registrar/domains/.+/registration$])
          .to_return(read_http_fixture("register/success.http"))
    end

    let(:attributes) { { registrant_id: "10" } }

    it "builds the correct request" do
      subject.register(account_id, domain_name = "example.com", attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/registration")
          .with(body: attributes)
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the domain" do
      response = subject.register(account_id, "example.com", attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe "#transfer" do
    let(:account_id) { 1010 }

    before do
      stub_request(:post, %r[/v2/#{account_id}/registrar/domains/.+/transfer$])
          .to_return(read_http_fixture("transferDomain/success.http"))
    end

    let(:attributes) { { registrant_id: "10", auth_info: "x1y2z3" } }

    it "builds the correct request" do
      subject.transfer(account_id, domain_name = "example.com", attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/transfer")
          .with(body: attributes)
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the domain" do
      response = subject.transfer(account_id, "example.com", attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.name).to eq("example.com")
      expect(result.registrant_id).to eq(10)
    end

    context "when the attributes are incomplete" do
      it "raises ArgumentError" do
        expect { subject.transfer(account_id, "example.com", auth_info: "x1y2z3") }.to raise_error(ArgumentError)
      end
    end

    context "when the domain is already in DNSimple" do
      it "raises a BadRequestError" do
        stub_request(:post, %r[/v2/#{account_id}/registrar/domains/.+/transfer$])
            .to_return(read_http_fixture("transferDomain/error-indnsimple.http"))

        expect {
          subject.transfer(account_id, "example.com", attributes)
        }.to raise_error(Dnsimple::RequestError)
      end
    end

    context "when :auth_info wasn't provided an is required by the TLD" do
      it "raises a BadRequestError" do
        stub_request(:post, %r[/v2/#{account_id}/registrar/domains/.+/transfer$])
            .to_return(read_http_fixture("transferDomain/error-missing-authcode.http"))

        expect {
          subject.transfer(account_id, "example.com", registrant_id: 10)
        }.to raise_error(Dnsimple::RequestError)
      end
    end
  end

  describe "#transfer_out" do
    let(:account_id) { 1010 }

    before do
      stub_request(:post, %r[/v2/#{account_id}/registrar/domains/.+/transfer_out$])
          .to_return(read_http_fixture("transferDomainOut/success.http"))
    end

    it "builds the correct request" do
      subject.transfer_out(account_id, domain_name = "example.com")

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/transfer_out")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.transfer_out(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end
  end

end
