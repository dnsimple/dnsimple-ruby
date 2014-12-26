require 'spec_helper'

describe Dnsimple::Client, ".services / domains" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").services }


  describe "#applied" do
    before do
      stub_request(:get, %r[/v1/domains/.+/applied_services$]).
          to_return(read_fixture("services/applied/success.http"))
    end

    it "builds the correct request" do
      subject.applied("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/applied_services").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the services" do
      results = subject.applied("example.com")

      expect(results).to be_a(Array)
      expect(results.size).to eq(1)

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Service)
        expect(result.id).to be_a(Fixnum)
      end
    end
  end

  describe "#available" do
    before do
      stub_request(:get, %r[/v1/domains/.+/available_services$]).
          to_return(read_fixture("services/available/success.http"))
    end

    it "builds the correct request" do
      subject.available("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/available_services").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the services" do
      results = subject.available("example.com")

      expect(results).to be_a(Array)
      expect(results.size).to eq(1)

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Service)
        expect(result.id).to be_a(Fixnum)
      end
    end
  end

  describe "#apply" do
    before do
      stub_request(:post, %r[/v1/domains/.+/applied_services$]).
          to_return(read_fixture("services/apply/success.http"))
    end

    it "builds the correct request" do
      subject.apply("example.com", "whatever")

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/example.com/applied_services").
                             with(body: { service: { id: "whatever" } }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      results = subject.apply("example.com", "whatever")

      expect(results).to be_truthy
    end
  end

  describe "#unapply" do
    before do
      stub_request(:delete, %r[/v1/domains/.+/applied_services/.+$]).
          to_return(read_fixture("services/unapply/success.http"))
    end

    it "builds the correct request" do
      subject.unapply("example.com", "whatever")

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/domains/example.com/applied_services/whatever").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      results = subject.unapply("example.com", "whatever")

      expect(results).to be_truthy
    end
  end

end
