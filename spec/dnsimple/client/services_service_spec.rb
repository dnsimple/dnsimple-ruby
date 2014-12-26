require 'spec_helper'

describe Dnsimple::Client, ".services" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").services }


  describe "#list" do
    before do
      stub_request(:get, %r[/v1/services$]).
          to_return(read_fixture("services/index/success.http"))
    end

    it "builds the correct request" do
      subject.list

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/services").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the services" do
      results = subject.list

      expect(results).to be_a(Array)
      expect(results.size).to eq(3)

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Service)
        expect(result.id).to be_a(Fixnum)
      end
    end
  end

  describe "#find" do
    before do
      stub_request(:get, %r[/v1/services/.+$]).
          to_return(read_fixture("services/show/success.http"))
    end

    it "builds the correct request" do
      subject.find(1)

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/services/1").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the service" do
      result = subject.find(1)

      expect(result).to be_a(Dnsimple::Struct::Service)
      expect(result.id).to eq(1)
      expect(result.name).to eq("Google Apps")
      expect(result.short_name).to eq("google-apps")
      expect(result.description).to eq("All the records you need for Google Apps to function.")
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("services/notfound.http"))

        expect {
          subject.find(1)
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

end
