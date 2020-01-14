# frozen_string_literal: true

require 'spec_helper'

describe Dnsimple::Client, ".services" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").services }


  describe "#list_services" do
    before do
      stub_request(:get, %r{/v2/services})
          .to_return(read_http_fixture("listServices/success.http"))
    end

    it "builds the correct request" do
      subject.list_services

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/services")
          .with(headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.services(page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/services?page=2")
    end

    it "supports extra request options" do
      subject.services(query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/services?foo=bar")
    end

    it "supports sorting" do
      subject.services(sort: "short_name:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/services?sort=short_name:asc")
    end

    it "returns the list of available services" do
      response = subject.list_services
      expect(response).to be_a(Dnsimple::CollectionResponse)

      response.data.each do |service|
        expect(service).to be_a(Dnsimple::Struct::Service)
        expect(service.id).to be_a(Integer)
        expect(service.name).to be_a(String)
        expect(service.sid).to be_a(String)
        expect(service.description).to be_a(String)

        service.settings.each do |service_setting|
          expect(service_setting).to be_a(Dnsimple::Struct::Service::Setting)
        end
      end
    end
  end

  describe "#all_services" do
    before do
      stub_request(:get, %r{/v2/services})
          .to_return(read_http_fixture("listServices/success.http"))
    end

    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:services, foo: "bar")
      subject.all_services(foo: "bar")
    end

    it "supports sorting" do
      subject.all_services(sort: "short_name:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/services?page=1&per_page=100&sort=short_name:asc")
    end
  end

  describe "#service" do
    let(:service_id) { 1 }

    before do
      stub_request(:get, %r{/v2/services/#{service_id}$})
          .to_return(read_http_fixture("getService/success.http"))
    end

    it "builds the correct request" do
      subject.service(service_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/services/#{service_id}")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the service" do
      response = subject.service(service_id)
      expect(response).to be_a(Dnsimple::Response)

      service = response.data
      expect(service).to be_a(Dnsimple::Struct::Service)
      expect(service.id).to eq(1)
      expect(service.name).to eq("Service 1")
      expect(service.sid).to eq("service1")
      expect(service.description).to eq("First service example.")
      expect(service.setup_description).to be_nil
      expect(service.requires_setup).to be(true)
      expect(service.default_subdomain).to be_nil

      settings = service.settings
      expect(settings).to be_a(Array)
      expect(settings.size).to eq(1)
      expect(settings[0].name).to eq("username")
    end
  end

end
