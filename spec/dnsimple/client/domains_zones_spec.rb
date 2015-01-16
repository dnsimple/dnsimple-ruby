require 'spec_helper'

describe Dnsimple::Client, ".domains / zones" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").domains }


  describe "#zone" do
    before do
      stub_request(:get, %r[/v1/domains/.+/zone$]).
          to_return(read_fixture("domains_zones/get/success.http"))
    end

    it "builds the correct request" do
      subject.zone("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/zone").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      result = subject.zone("example.com")

      expect(result).to be_a(String)
      expect(result).to match(/^#{Regexp.escape("$ORIGIN")}/)
    end

    context "when domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("domains_zones/notfound-domain.http"))

        expect {
          subject.zone("example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
