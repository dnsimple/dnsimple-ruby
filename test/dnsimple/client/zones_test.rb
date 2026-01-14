# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".zones" do
  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").zones }


  describe "#zones" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/zones})
          .to_return(read_http_fixture("listZones/success.http"))
    end

    it "builds the correct request" do
      subject.zones(account_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones",
                       headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.zones(account_id, page: 2)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones?page=2")
    end

    it "supports extra request options" do
      subject.zones(account_id, query: { foo: "bar" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones?foo=bar")
    end

    it "supports sorting" do
      subject.zones(account_id, sort: "name:desc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones?sort=name:desc")
    end

    it "supports filtering" do
      subject.zones(account_id, filter: { name_like: "example" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones?name_like=example")
    end

    it "returns the zones" do
      response = subject.zones(account_id)

      _(response).must_be_kind_of(Dnsimple::PaginatedResponse)
      _(response.data).must_be_kind_of(Array)
      _(response.data.size).must_equal(2)

      response.data.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::Zone)
        _(result.id).must_be_kind_of(Integer)
      end
    end

    it "exposes the pagination information" do
      response = subject.zones(account_id)

      _(response).must_respond_to(:page)
      _(response.page).must_equal(1)
      _(response.per_page).must_be_kind_of(Integer)
      _(response.total_entries).must_be_kind_of(Integer)
      _(response.total_pages).must_be_kind_of(Integer)
    end
  end

  describe "#all_zones" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/zones})
          .to_return(read_http_fixture("listZones/success.http"))
    end

    let(:account_id) { 1010 }

    it "delegates to client.paginate" do
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [:zones, account_id, { foo: "bar" }])
      subject.stub(:paginate, mock) do
        subject.all_zones(account_id, { foo: "bar" })
      end
      mock.verify
    end

    it "supports sorting" do
      subject.all_zones(account_id, sort: "name:desc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones?page=1&per_page=100&sort=name:desc")
    end

    it "supports filtering" do
      subject.all_zones(account_id, filter: { name_like: "zone.test" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones?page=1&per_page=100&name_like=zone.test")
    end
  end

  describe "#zone" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/zones/.+$})
          .to_return(read_http_fixture("getZone/success.http"))
    end

    it "builds the correct request" do
      subject.zone(account_id, zone = "example.com")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the zone" do
      response = subject.zone(account_id, "example.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Zone)
      _(result.id).must_equal(1)
      _(result.account_id).must_equal(1010)
      _(result.name).must_equal("example-alpha.com")
      _(result.reverse).must_equal(false)
      _(result.secondary).must_equal(false)
      _(result.last_transferred_at).must_be_nil
      _(result.active).must_equal(true)
      _(result.created_at).must_equal("2015-04-23T07:40:03Z")
      _(result.updated_at).must_equal("2015-04-23T07:40:03Z")
    end

    describe "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        _ {
          subject.zone(account_id, "example.com")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#zone_file" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/zones/.+$})
          .to_return(read_http_fixture("getZoneFile/success.http"))
    end

    it "builds the correct request" do
      subject.zone_file(account_id, zone = "example.com")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone}/file",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the zone id" do
      response = subject.zone_file(account_id, "example.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::ZoneFile)
      _(result.zone).must_equal("$ORIGIN example.com.\n$TTL 1h\nexample.com. 3600 IN SOA ns1.dnsimple.com. admin.dnsimple.com. 1453132552 86400 7200 604800 300\nexample.com. 3600 IN NS ns1.dnsimple.com.\nexample.com. 3600 IN NS ns2.dnsimple.com.\nexample.com. 3600 IN NS ns3.dnsimple.com.\nexample.com. 3600 IN NS ns4.dnsimple.com.\n")
    end

    describe "when the zone file does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        _ {
          subject.zone_file(account_id, "example.com")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#activate_dns" do
    let(:account_id) { 1010 }

    before do
      stub_request(:put, %r{/v2/#{account_id}/zones/.+/activation})
          .to_return(read_http_fixture("activateZoneService/success.http"))
    end

    it "builds the correct request" do
      subject.activate_dns(account_id, zone = "example.com")

      assert_requested(:put, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone}/activation",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the zone" do
      response = subject.activate_dns(account_id, "example.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Zone)
      _(result.id).must_equal(1)
      _(result.account_id).must_equal(1010)
      _(result.name).must_equal("example.com")
      _(result.reverse).must_equal(false)
      _(result.active).must_equal(true)
      _(result.created_at).must_equal("2022-09-28T04:45:24Z")
      _(result.updated_at).must_equal("2023-07-06T11:19:48Z")
    end

    describe "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:put, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        _ {
          subject.activate_dns(account_id, "example.com")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#deactivate_dns" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/zones/.+/activation})
          .to_return(read_http_fixture("deactivateZoneService/success.http"))
    end

    it "builds the correct request" do
      subject.deactivate_dns(account_id, zone = "example.com")

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone}/activation",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the zone" do
      response = subject.deactivate_dns(account_id, "example.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Zone)
      _(result.id).must_equal(1)
      _(result.account_id).must_equal(1010)
      _(result.name).must_equal("example.com")
      _(result.reverse).must_equal(false)
      _(result.active).must_equal(false)
      _(result.created_at).must_equal("2022-09-28T04:45:24Z")
      _(result.updated_at).must_equal("2023-08-08T04:19:52Z")
    end

    describe "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        _ {
          subject.deactivate_dns(account_id, "example.com")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end
end
