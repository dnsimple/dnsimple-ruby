require 'spec_helper'

describe Dnsimple::Client, ".registrar" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").registrar }


  describe "#check" do
    before do
      stub_request(:get, %r[/v1/domains/.+/check$]).
          to_return(read_fixture("registrar/check/registered.http"))
    end

    it "builds the correct request" do
      subject.check("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/check").
                             with(headers: { 'Accept' => 'application/json' })
    end

    context "the domain is registered" do
      before do
        stub_request(:get, %r[/v1/domains/.+/check$]).
            to_return(read_fixture("registrar/check/registered.http"))
      end

      it "returns available" do
        expect(subject.check("example.com")).to eq("registered")
      end
    end

    context "the domain is available" do
      before do
        stub_request(:get, %r[/v1/domains/.+/check$]).
            to_return(read_fixture("registrar/check/available.http"))
      end

      it "returns available" do
        expect(subject.check("example.com")).to eq("available")
      end
    end
  end

  describe "#register" do
    before do
      stub_request(:post, %r[/v1/domain_registrations]).
          to_return(read_fixture("registrar/register/success.http"))
    end

    it "builds the correct request" do
      subject.register("example.com", 10)

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domain_registrations").
                             with(body: { domain: { name: "example.com", registrant_id: "10" }}).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.register("example.com", 10)

      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe "#renew" do
    before do
      stub_request(:post, %r[/v1/domain_renewals]).
          to_return(read_fixture("registrar/renew/success.http"))
    end

    it "builds the correct request" do
      subject.renew("example.com")

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domain_renewals").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.renew("example.com")

      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to be_a(Fixnum)
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("domains/notfound.http"))

        expect {
          subject.renew("example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end


  describe "#list_extended_attributes" do
    before do
      stub_request(:get, %r[/v1/extended_attributes/.+$]).
          to_return(read_fixture("registrar_extended_attributes/list/success.http"))
    end

    it "builds the correct request" do
      subject.list_extended_attributes("uk")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/extended_attributes/uk").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the extended attributes" do
      results = subject.list_extended_attributes("uk")

      expect(results).to be_a(Array)
      expect(results.size).to eq(4)

      result = results[0]
      expect(result).to be_a(Dnsimple::Struct::ExtendedAttribute)
      expect(result.name).to eq("uk_legal_type")
      expect(result.description).to eq("Legal type of registrant contact")
      expect(result.required).to eq(false)
      expect(result.options).to be_a(Array)
      expect(result.options.size).to eq(17)

      option = result.options[0]
      expect(option.title).to eq("UK Individual")
      expect(option.value).to eq("IND")
      expect(option.description).to eq("UK Individual (our default value)")
    end
  end


  describe "#list_prices" do
    before do
      stub_request(:get, %r[/v1/prices$]).
          to_return(read_fixture("registrar_prices/list/success.http"))
    end

    it "builds the correct request" do
      subject.list_prices

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/prices").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the prices" do
      results = subject.list_prices

      expect(results).to be_a(Array)
      expect(results.size).to be > 0

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Price)
        expect(result.tld).to be_a(String)
      end
    end
  end

end
