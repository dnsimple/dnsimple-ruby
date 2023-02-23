# frozen_string_literal: true

require 'spec_helper'

describe Dnsimple::Client, ".registrar" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar }


  describe "#check_domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/.+/check$})
          .to_return(read_http_fixture("checkDomain/success.http"))
    end

    it "builds the correct request" do
      subject.check_domain(account_id, domain_name = "example.com")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/check")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the availability" do
      response = subject.check_domain(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DomainCheck)
      expect(result.domain).to eq("ruby.codes")
      expect(result.available).to be(true)
      expect(result.premium).to be(true)
    end
  end

  describe "#get_domain_prices" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/bingo.pizza/prices$})
          .to_return(read_http_fixture("getDomainPrices/success.http"))
    end

    it "builds the correct request" do
      subject.get_domain_prices(account_id, "bingo.pizza")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/bingo.pizza/prices")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the prices" do
      response = subject.get_domain_prices(account_id, "bingo.pizza")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data

      expect(result).to be_a(Dnsimple::Struct::DomainPrice)
      expect(result.domain).to eq("bingo.pizza")
      expect(result.premium).to be(true)
      expect(result.registration_price).to eq(20.0)
      expect(result.renewal_price).to eq(20.0)
      expect(result.transfer_price).to eq(20.0)
    end

    context "when the TLD is not supported" do
      before do
        stub_request(:get, %r{/v2/#{account_id}/registrar/domains/bingo.pineapple/prices$})
            .to_return(read_http_fixture("getDomainPrices/failure.http"))
      end

      it "raises error" do
        expect {
          subject.get_domain_prices(account_id, "bingo.pineapple")
        }.to raise_error(Dnsimple::RequestError, "TLD .PINEAPPLE is not supported")
      end
    end
  end

  describe "#register_domain" do
    let(:account_id) { 1010 }
    let(:attributes) { { registrant_id: "10" } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/registrations$})
          .to_return(read_http_fixture("registerDomain/success.http"))
    end


    it "builds the correct request" do
      subject.register_domain(account_id, domain_name = "example.com", attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/registrations")
          .with(body: attributes)
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the domain" do
      response = subject.register_domain(account_id, "example.com", attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DomainRegistration)
      expect(result.id).to be_a(Integer)
      expect(result.domain_id).to be_a(Integer)
    end

    context "when the attributes are incomplete" do
      it "raises ArgumentError" do
        expect { subject.register_domain(account_id, "example.com") }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#get_domain_registration" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/.+/registrations/.+$})
          .to_return(read_http_fixture("getDomainRegistration/success.http"))
    end

    it "builds the correct request" do
      subject.get_domain_registration(account_id, domain_name = "example.com", registration_id = 361)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/registrations/#{registration_id}")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the domain transfer" do
      response = subject.get_domain_registration(account_id, "example.com", 361)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DomainRegistration)
      expect(result.id).to be_a(Integer)
      expect(result.domain_id).to be_a(Integer)
    end
  end

  describe "#renew_domain" do
    let(:account_id) { 1010 }
    let(:attributes) { { period: "3" } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/renewals$})
          .to_return(read_http_fixture("renewDomain/success.http"))
    end


    it "builds the correct request" do
      subject.renew_domain(account_id, domain_name = "example.com", attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/renewals")
          .with(body: attributes)
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the domain" do
      response = subject.renew_domain(account_id, "example.com", attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DomainRenewal)
      expect(result.id).to be_a(Integer)
      expect(result.domain_id).to be_a(Integer)
    end

    context "when it is too soon for the domain to be renewed" do
      it "raises a BadRequestError" do
        stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/renewals$})
            .to_return(read_http_fixture("renewDomain/error-tooearly.http"))

        expect {
          subject.renew_domain(account_id, "example.com", attributes)
        }.to raise_error(Dnsimple::RequestError)
      end
    end
  end

  describe "#get_domain_renewal" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/.+/renewals/.+$})
          .to_return(read_http_fixture("getDomainRenewal/success.http"))
    end

    it "builds the correct request" do
      subject.get_domain_renewal(account_id, domain_name = "example.com", renewal_id = 361)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/renewals/#{renewal_id}")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the domain renewal" do
      response = subject.get_domain_renewal(account_id, "example.com", 361)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DomainRenewal)
      expect(result.id).to be_a(Integer)
      expect(result.domain_id).to be_a(Integer)
    end
  end

  describe "#transfer_domain" do
    let(:account_id) { 1010 }
    let(:attributes) { { registrant_id: "10", auth_code: "x1y2z3" } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/transfers$})
          .to_return(read_http_fixture("transferDomain/success.http"))
    end


    it "builds the correct request" do
      subject.transfer_domain(account_id, domain_name = "example.com", attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/transfers")
          .with(body: attributes)
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the domain" do
      response = subject.transfer_domain(account_id, "example.com", attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DomainTransfer)
      expect(result.id).to be_a(Integer)
      expect(result.domain_id).to be_a(Integer)
    end

    context "when the attributes are incomplete" do
      it "raises ArgumentError" do
        expect { subject.transfer_domain(account_id, "example.com", auth_code: "x1y2z3") }.to raise_error(ArgumentError)
      end
    end

    context "when the domain is already in DNSimple" do
      it "raises a BadRequestError" do
        stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/transfers$})
            .to_return(read_http_fixture("transferDomain/error-indnsimple.http"))

        expect {
          subject.transfer_domain(account_id, "example.com", attributes)
        }.to raise_error(Dnsimple::RequestError)
      end
    end

    context "when :auth_code wasn't provided and is required by the TLD" do
      it "raises a BadRequestError" do
        stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/transfers$})
            .to_return(read_http_fixture("transferDomain/error-missing-authcode.http"))

        expect {
          subject.transfer_domain(account_id, "example.com", registrant_id: 10)
        }.to raise_error(Dnsimple::RequestError)
      end
    end
  end

  describe "#get_transfer_domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/.+/transfers/.+$})
          .to_return(read_http_fixture("getDomainTransfer/success.http"))
    end

    it "builds the correct request" do
      subject.get_domain_transfer(account_id, domain_name = "example.com", transfer_id = 361)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/transfers/#{transfer_id}")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the domain transfer" do
      response = subject.get_domain_transfer(account_id, "example.com", 361)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DomainTransfer)
      expect(result.id).to eq(361)
      expect(result.domain_id).to eq(182245)
      expect(result.registrant_id).to eq(2715)
      expect(result.state).to eq("cancelled")
      expect(result.auto_renew).to be(false)
      expect(result.whois_privacy).to be(false)
      expect(result.status_description).to eq("Canceled by customer")
      expect(result.created_at).to eq("2020-06-05T18:08:00Z")
      expect(result.updated_at).to eq("2020-06-05T18:10:01Z")
    end
  end

  describe "#cancel_domain_transfer" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/registrar/domains/.+/transfers/.+$})
          .to_return(read_http_fixture("cancelDomainTransfer/success.http"))
    end

    it "builds the correct request" do
      subject.cancel_domain_transfer(account_id, domain_name = "example.com", transfer_id = 361)

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/transfers/#{transfer_id}")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the domain transfer" do
      response = subject.cancel_domain_transfer(account_id, "example.com", 361)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DomainTransfer)
      expect(result.id).to eq(361)
      expect(result.domain_id).to eq(182245)
      expect(result.registrant_id).to eq(2715)
      expect(result.state).to eq("transferring")
      expect(result.auto_renew).to be(false)
      expect(result.whois_privacy).to be(false)
      expect(result.status_description).to be_nil
      expect(result.created_at).to eq("2020-06-05T18:08:00Z")
      expect(result.updated_at).to eq("2020-06-05T18:08:04Z")
    end
  end


  describe "#transfer_domain_out" do
    let(:account_id) { 1010 }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/domains/.+/authorize_transfer_out$})
          .to_return(read_http_fixture("authorizeDomainTransferOut/success.http"))
    end

    it "builds the correct request" do
      subject.transfer_domain_out(account_id, domain_name = "example.com")

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_name}/authorize_transfer_out")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.transfer_domain_out(account_id, "example.com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end
  end

end
