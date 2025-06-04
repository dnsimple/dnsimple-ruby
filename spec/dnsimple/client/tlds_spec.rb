# frozen_string_literal: true

require "spec_helper"

describe Dnsimple::Client, ".tlds" do
  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").tlds }

  describe "#list_tlds" do
    before do
      stub_request(:get, %r{/v2/tlds})
          .to_return(read_http_fixture("listTlds/success.http"))
    end

    it "builds the correct request" do
      subject.list_tlds

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/tlds")
          .with(headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.list_tlds(page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/tlds?page=2")
    end

    it "supports additional options" do
      subject.list_tlds(query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/tlds?foo=bar")
    end

    it "supports sorting" do
      subject.list_tlds(sort: "tld:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/tlds?sort=tld:asc")
    end

    it "returns the tlds" do
      response = subject.list_tlds

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_an(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Tld)
        expect(result.tld_type).to be_a(Integer)
        expect(result.tld).to be_a(String)
      end
    end

    it "exposes the pagination information" do
      response = subject.list_tlds

      expect(response.respond_to?(:page)).to be(true)
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Integer)
      expect(response.total_entries).to be_a(Integer)
      expect(response.total_pages).to be_a(Integer)
    end
  end

  describe "#all_tlds" do
    before do
      stub_request(:get, %r{/v2/tlds})
          .to_return(read_http_fixture("listTlds/success.http"))
    end

    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:list_tlds, { foo: "bar" })
      subject.all_tlds(foo: "bar")
    end

    it "supports sorting" do
      subject.all_tlds(sort: "tld:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/tlds?page=1&per_page=100&sort=tld:asc")
    end
  end

  describe "#tld" do
    before do
      stub_request(:get, %r{/v2/tlds/.+$})
          .to_return(read_http_fixture("getTld/success.http"))
    end

    it "builds the correct request" do
      subject.tld(tld = "com")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/tlds/#{tld}")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the tld" do
      response = subject.tld("com")
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Tld)
      expect(result.tld).to eq("com")
      expect(result.tld_type).to eq(1)
      expect(result.whois_privacy).to be(true)
      expect(result.auto_renew_only).to be(false)
      expect(result.idn).to be(true)
      expect(result.minimum_registration).to eq(1)
      expect(result.registration_enabled).to be(true)
      expect(result.renewal_enabled).to be(true)
      expect(result.transfer_enabled).to be(true)
      expect(result.dnssec_interface_type).to eq("ds")
    end
  end

  describe "#tld_extended_attributes" do
    before do
      stub_request(:get, %r{/v2/tlds/uk/extended_attributes$})
          .to_return(read_http_fixture("getTldExtendedAttributes/success.http"))
    end

    it "builds the correct request" do
      subject.tld_extended_attributes(tld = "uk")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/tlds/#{tld}/extended_attributes")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the extended attributes" do
      response = subject.tld_extended_attributes("uk")
      expect(response).to be_a(Dnsimple::CollectionResponse)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::ExtendedAttribute)
        expect(result.name).to be_a(String)
        expect(result.description).to be_a(String)
        expect(result).to respond_to(:required)

        next if result.options.empty?

        result.options.each do |option|
          expect(option).to be_a(Dnsimple::Struct::ExtendedAttribute::Option)
          expect(option.title).to be_a(String)
          expect(option.value).to be_a(String)
          expect(option.description).to be_a(String)
        end
      end
    end

    context "when there are no extended attributes for a TLD" do
      before do
        stub_request(:get, %r{/v2/tlds/com/extended_attributes$})
            .to_return(read_http_fixture("getTldExtendedAttributes/success-noattributes.http"))
      end

      it "returns an empty CollectionResponse" do
        response = subject.tld_extended_attributes("com")
        expect(response).to be_a(Dnsimple::CollectionResponse)

        result = response.data
        expect(result).to be_empty
      end
    end
  end
end
