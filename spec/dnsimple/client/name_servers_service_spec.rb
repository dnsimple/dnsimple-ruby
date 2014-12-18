require 'spec_helper'

describe Dnsimple::Client, ".name_servers" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").name_servers }


  describe "#list" do
    before do
      stub_request(:get, %r[/v1/domains/.+/name_servers]).
          to_return(read_fixture("nameservers/success.http"))
    end

    it "builds the correct request" do
      subject.list("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/name_servers").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the name servers" do
      expect(subject.list("example.com")).to eq(%w( ns1.dnsimple.com ns2.dnsimple.com ))
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("nameservers/notfound.http"))

        expect {
          subject.list("example.com")
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe "#change" do
    before do
      stub_request(:post, %r[/v1/domains/.+/name_servers]).
          to_return(read_fixture("nameservers/success.http"))
    end

    it "builds the correct request" do
      subject.change("example.com", %w( ns1.example.com ns2.example.com ))

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/example.com/name_servers").
                         with(body: { "name_servers" => { "ns1" => "ns1.example.com", "ns2" => "ns2.example.com" }}).
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the name servers" do
      expect(subject.change("example.com", %w())).to eq(%w( ns1.dnsimple.com ns2.dnsimple.com ))
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("nameservers/notfound.http"))

        expect {
          subject.change("example.com", %w())
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

end
