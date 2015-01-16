require 'spec_helper'

describe Dnsimple::Client, ".domains / autorenewals" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").domains }


  describe "#enable_auto_renewal" do
    before do
      stub_request(:post, %r[/v1/domains/.+/auto_renewal$]).
          to_return(read_fixture("domains_autorenewal/enable/success.http"))
    end

    it "builds the correct request" do
      subject.enable_auto_renewal("example.com")

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/example.com/auto_renewal").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.enable_auto_renewal("example.com")

      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to be_a(Fixnum)
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("domains_autorenewal/notfound-domain.http"))

        expect {
          subject.enable_auto_renewal("example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#disable_auto_renewal" do
    before do
      stub_request(:delete, %r[/v1/domains/.+/auto_renewal$]).
          to_return(read_fixture("domains_autorenewal/disable/success.http"))
    end

    it "builds the correct request" do
      subject.disable_auto_renewal("example.com")

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/domains/example.com/auto_renewal").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.disable_auto_renewal("example.com")

      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to be_a(Fixnum)
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("domains_autorenewal/notfound-domain.http"))

        expect {
          subject.disable_auto_renewal("example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
