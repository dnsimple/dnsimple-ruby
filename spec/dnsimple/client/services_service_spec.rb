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
