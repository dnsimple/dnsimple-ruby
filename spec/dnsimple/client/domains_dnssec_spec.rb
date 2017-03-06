require 'spec_helper'

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }

  describe "#enable_dnssec" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/dnssec}).
          to_return(read_http_fixture("enableDnssec/success.http"))
    end


    it "builds the correct request" do
      subject.enable_dnssec(account_id, domain_id)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/dnssec").
          with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the dnssec status" do
      response = subject.enable_dnssec(account_id, domain_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Dnssec)
      expect(result.enabled).to be_truthy
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2}).
            to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.enable_dnssec(account_id, domain_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end

  end

  describe "#disable_dnssec" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/domains/#{domain_id}/dnssec}).
          to_return(read_http_fixture("disableDnssec/success.http"))
    end


    it "builds the correct request" do
      subject.disable_dnssec(account_id, domain_id)

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/dnssec").
          with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      response = subject.disable_dnssec(account_id, domain_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2}).
            to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.disable_dnssec(account_id, domain_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end
end
