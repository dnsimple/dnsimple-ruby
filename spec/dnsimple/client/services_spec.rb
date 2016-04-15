require 'spec_helper'

describe Dnsimple::Client, ".services" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").services }


  describe "#list_services" do
    before do
      stub_request(:get, %r{/v2/services$}).
          to_return(read_http_fixture("listServices/success.http"))
    end

    it "builds the correct request" do
      subject.list_services

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/services").
          with(headers: { "Accept" => "application/json" })
    end

    it "returns the list of available services" do
      response = subject.list_services
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

  describe "#all_services" do
    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:services, foo: "bar")
      subject.all_services(foo: "bar")
    end
  end

end
