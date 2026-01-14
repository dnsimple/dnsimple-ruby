# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".services" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").services }


  describe "#list_services" do
    before do
      stub_request(:get, %r{/v2/services})
          .to_return(read_http_fixture("listServices/success.http"))
    end

    it "builds the correct request" do
      subject.list_services

      assert_requested(:get, "https://api.dnsimple.test/v2/services",
                       headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.services(page: 2)

      assert_requested(:get, "https://api.dnsimple.test/v2/services?page=2")
    end

    it "supports extra request options" do
      subject.services(query: { foo: "bar" })

      assert_requested(:get, "https://api.dnsimple.test/v2/services?foo=bar")
    end

    it "supports sorting" do
      subject.services(sort: "short_name:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/services?sort=short_name:asc")
    end

    it "returns the list of available services" do
      response = subject.list_services
      _(response).must_be_kind_of(Dnsimple::CollectionResponse)

      response.data.each do |service|
        _(service).must_be_kind_of(Dnsimple::Struct::Service)
        _(service.id).must_be_kind_of(Integer)
        _(service.name).must_be_kind_of(String)
        _(service.sid).must_be_kind_of(String)
        _(service.description).must_be_kind_of(String)

        service.settings.each do |setting|
          _(setting).must_be_kind_of(Dnsimple::Struct::Service::Setting)
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
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [:services, { foo: "bar" }])
      subject.stub(:paginate, mock) do
        subject.all_services(foo: "bar")
      end
      mock.verify
    end

    it "supports sorting" do
      subject.all_services(sort: "short_name:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/services?page=1&per_page=100&sort=short_name:asc")
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

      assert_requested(:get, "https://api.dnsimple.test/v2/services/#{service_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the service" do
      response = subject.service(service_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      service = response.data
      _(service).must_be_kind_of(Dnsimple::Struct::Service)
      _(service.id).must_equal(1)
      _(service.name).must_equal("Service 1")
      _(service.sid).must_equal("service1")
      _(service.description).must_equal("First service example.")
      _(service.setup_description).must_be_nil
      _(service.requires_setup).must_equal(true)
      _(service.default_subdomain).must_be_nil

      settings = service.settings
      _(settings).must_be_kind_of(Array)
      _(settings.size).must_equal(1)
      _(settings[0].name).must_equal("username")
    end
  end

end
