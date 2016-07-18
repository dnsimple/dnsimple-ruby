require 'spec_helper'

describe Dnsimple::Client, ".domain_services" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domain_services }


  describe "#applied_services" do
    let(:account_id) { 1010 }
    let(:domain_id)  { 'example.com' }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/services}).
          to_return(read_http_fixture("appliedServices/success.http"))
    end

    it "builds the correct request" do
      subject.applied_services(account_id, domain_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/services").
          with(headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.applied_services(account_id, domain_id, page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/services?page=2")
    end

    it "supports extra request options" do
      subject.applied_services(account_id, domain_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/services?foo=bar")
    end

    it "supports sorting" do
      subject.applied_services(account_id, domain_id, sort: "short_name:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/services?sort=short_name:asc")
    end

    it "returns the list of available services" do
      response = subject.applied_services(account_id, domain_id)
      expect(response).to be_a(Dnsimple::CollectionResponse)

      response.data.each do |service|
        expect(service).to be_a(Dnsimple::Struct::Service)
        expect(service.id).to be_a(Fixnum)
        expect(service.name).to be_a(String)
        expect(service.short_name).to be_a(String)
        expect(service.description).to be_a(String)

        service.settings.each do |service_setting|
          expect(service_setting).to be_a(Dnsimple::Struct::Service::Setting)
        end
      end
    end
  end

  describe "#apply_service" do
    let(:account_id) { 1010 }
    let(:domain_id)  { "example.com" }
    let(:service_id) { "service1" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/services/#{service_id}$}).
          to_return(read_http_fixture("applyService/created.http"))
    end

    let(:settings) { { app: "foo" } }

    it "builds the correct request" do
      subject.apply_service(account_id, domain_id, service_id, settings)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/services/#{service_id}").
          with(body: settings).
          with(headers: { 'Accept' => 'application/json' })
    end

    it "returns empty response" do
      response = subject.apply_service(account_id, domain_id, service_id, settings)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end
  end

end
