# frozen_string_literal: true

require 'spec_helper'

describe Dnsimple::Client, ".registrar" do
  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").registrar }

  describe "#get_domain_transfer_lock" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/registrar/domains/#{domain_id}/transfer_lock})
          .to_return(read_http_fixture("getDomainTransferLock/success.http"))
    end

    it "builds the correct request" do
      subject.get_domain_transfer_lock(account_id, domain_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_id}/transfer_lock")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the transfer lock state" do
      response = subject.get_domain_transfer_lock(account_id, domain_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::TransferLock)
      expect(result.enabled).to be(true)
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.get_domain_transfer_lock(account_id, domain_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#enable_domain_transfer_lock" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/registrar/domains/#{domain_id}/transfer_lock})
          .to_return(read_http_fixture("enableDomainTransferLock/success.http"))
    end

    it "builds the correct request" do
      subject.enable_domain_transfer_lock(account_id, domain_id)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_id}/transfer_lock")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the transfer lock state" do
      response = subject.enable_domain_transfer_lock(account_id, domain_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::TransferLock)
      expect(result.enabled).to be(true)
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.enable_domain_transfer_lock(account_id, domain_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#disable_domain_transfer_lock" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/registrar/domains/#{domain_id}})
          .to_return(read_http_fixture("disableDomainTransferLock/success.http"))
    end

    it "builds the correct request" do
      subject.disable_domain_transfer_lock(account_id, domain_id)

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/registrar/domains/#{domain_id}/transfer_lock")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the transfer lock state" do
      response = subject.disable_domain_transfer_lock(account_id, domain_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::TransferLock)
      expect(result.enabled).to be(false)
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.disable_domain_transfer_lock(account_id, domain_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end
end
