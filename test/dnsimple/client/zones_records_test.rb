# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".zones" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").zones }


  describe "#list_zone_records" do
    let(:account_id) { 1010 }
    let(:zone_id) { "example.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/zones/#{zone_id}/records})
          .to_return(read_http_fixture("listZoneRecords/success.http"))
    end

    it "builds the correct request" do
      subject.list_zone_records(account_id, zone_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records",
                       headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.list_zone_records(account_id, zone_id, page: 2)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?page=2")
    end

    it "supports extra request options" do
      subject.list_zone_records(account_id, zone_id, query: { foo: "bar" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?foo=bar")
    end

    it "supports sorting" do
      subject.list_zone_records(account_id, zone_id, sort: "type:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?sort=type:asc")
    end

    it "supports filtering" do
      subject.list_zone_records(account_id, zone_id, filter: { type: "A" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?type=A")
    end

    it "returns the records" do
      response = subject.list_zone_records(account_id, zone_id)

      _(response).must_be_kind_of(Dnsimple::PaginatedResponse)
      _(response.data).must_be_kind_of(Array)
      _(response.data.size).must_equal(5)

      response.data.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::ZoneRecord)
        _(result.id).must_be_kind_of(Integer)
        _(result.regions).must_be_kind_of(Array)
      end
    end

    it "exposes the pagination information" do
      response = subject.list_zone_records(account_id, zone_id)

      _(response).must_respond_to(:page)
      _(response.page).must_equal(1)
      _(response.per_page).must_be_kind_of(Integer)
      _(response.total_entries).must_be_kind_of(Integer)
      _(response.total_pages).must_be_kind_of(Integer)
    end

    describe "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        _ {
          subject.list_zone_records(account_id, zone_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#all_zone_records" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/zones/#{zone_id}/records})
          .to_return(read_http_fixture("listZoneRecords/success.http"))
    end

    let(:account_id) { 1010 }
    let(:zone_id) { "example.com" }

    it "delegates to client.paginate" do
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [:list_zone_records, account_id, zone_id, { foo: "bar" }])
      subject.stub(:paginate, mock) do
        subject.all_zone_records(account_id, zone_id, { foo: "bar" })
      end
      mock.verify
    end

    it "supports sorting" do
      subject.all_zone_records(account_id, zone_id, sort: "type:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?page=1&per_page=100&sort=type:asc")
    end

    it "supports filtering" do
      subject.all_zone_records(account_id, zone_id, filter: { name: "foo", type: "AAAA" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records?page=1&per_page=100&name=foo&type=AAAA")
    end
  end

  describe "#create_zone_record" do
    let(:account_id) { 1010 }
    let(:attributes) { { type: "A", name: "www", content: "127.0.0.1", regions: %w[global] } }
    let(:zone_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/zones/#{zone_id}/records$})
          .to_return(read_http_fixture("createZoneRecord/created.http"))
    end


    it "builds the correct request" do
      subject.create_zone_record(account_id, zone_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the record" do
      response = subject.create_zone_record(account_id, zone_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::ZoneRecord)
      _(result.id).must_equal(1)
      _(result.type).must_equal(attributes.fetch(:type))
      _(result.name).must_equal(attributes.fetch(:name))
      _(result.content).must_equal(attributes.fetch(:content))
      _(result.regions).must_equal(attributes.fetch(:regions))
    end

    describe "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        _ {
          subject.create_zone_record(account_id, zone_id, attributes)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#zone_record" do
    let(:account_id) { 1010 }
    let(:zone_id) { "example.com" }
    let(:record_id) { 5 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/zones/#{zone_id}/records/.+$})
          .to_return(read_http_fixture("getZoneRecord/success.http"))
    end

    it "builds the correct request" do
      subject.zone_record(account_id, zone_id, record_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the record" do
      response = subject.zone_record(account_id, zone_id, record_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::ZoneRecord)
      _(result.id).must_equal(record_id)
      _(result.zone_id).must_equal("example.com")
      _(result.parent_id).must_be_nil
      _(result.type).must_equal("MX")
      _(result.name).must_equal("")
      _(result.content).must_equal("mxa.example.com")
      _(result.ttl).must_equal(600)
      _(result.priority).must_equal(10)
      _(result.system_record).must_equal(false)
      _(result.regions).must_equal(%w[SV1 IAD])
      _(result.created_at).must_equal("2016-10-05T09:51:35Z")
      _(result.updated_at).must_equal("2016-10-05T09:51:35Z")
    end

    describe "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        _ {
          subject.zone_record(account_id, zone_id, "0")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end

    describe "when the record does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-record.http"))

        _ {
          subject.zone_record(account_id, zone_id, "0")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#update_zone_record" do
    let(:account_id) { 1010 }
    let(:attributes) { { content: "mxb.example.com", priority: "20", regions: ["global"] } }
    let(:zone_id) { "example.com" }
    let(:record_id) { 5 }

    before do
      stub_request(:patch, %r{/v2/#{account_id}/zones/#{zone_id}/records/.+$})
          .to_return(read_http_fixture("updateZoneRecord/success.http"))
    end


    it "builds the correct request" do
      subject.update_zone_record(account_id, zone_id, record_id, attributes)

      assert_requested(:patch, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the record" do
      response = subject.update_zone_record(account_id, zone_id, record_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::ZoneRecord)
      _(result.id).must_equal(record_id)
      _(result.content).must_equal(attributes.fetch(:content))
      _(result.priority).must_equal(attributes.fetch(:priority).to_i)
      _(result.regions).must_equal(attributes.fetch(:regions))
    end

    describe "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:patch, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        _ {
          subject.update_zone_record(account_id, zone_id, "0", {})
        }.must_raise(Dnsimple::NotFoundError)
      end
    end

    describe "when the record does not exist" do
      it "raises NotFoundError" do
        stub_request(:patch, %r{/v2})
            .to_return(read_http_fixture("notfound-record.http"))

        _ {
          subject.update_zone_record(account_id, zone_id, "0", {})
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_zone_record" do
    let(:account_id) { 1010 }
    let(:zone_id) { "example.com" }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/zones/#{zone_id}/records/.+$})
          .to_return(read_http_fixture("deleteZoneRecord/success.http"))
    end

    it "builds the correct request" do
      subject.delete_zone_record(account_id, zone_id, record_id = 2)

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/records/#{record_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.delete_zone_record(account_id, zone_id, 2)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end

    describe "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        _ {
          subject.delete_zone_record(account_id, zone_id, "0")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end

    describe "when the record does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-record.http"))

        _ {
          subject.delete_zone_record(account_id, zone_id, "0")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#batch_change_zone_records" do
    let(:account_id) { 1010 }
    let(:attributes) { { creates: [{ type: "A", content: "3.2.3.4", name: "ab" }, { type: "A", content: "4.2.3.4", name: "ab" }], updates: [{ id: 67622534, content: "3.2.3.40", name: "update1-1757049890" }, { id: 67622537, content: "5.2.3.40", name: "update2-1757049890" }], deletes: [{ id: 67622509 }, { id: 67622527 }] } }
    let(:zone_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/zones/#{zone_id}/batch$})
          .to_return(read_http_fixture("batchChangeZoneRecords/success.http"))
    end


    it "builds the correct request" do
      subject.batch_change_zone_records(account_id, zone_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/zones/#{zone_id}/batch",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the result" do
      response = subject.batch_change_zone_records(account_id, zone_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::ZoneRecordsBatchChange)
      _(result.creates[0].id).must_equal(67623409)
      _(result.creates[0].type).must_equal(attributes.fetch(:creates)[0].fetch(:type))
      _(result.creates[0].name).must_equal(attributes.fetch(:creates)[0].fetch(:name))
      _(result.creates[0].content).must_equal(attributes.fetch(:creates)[0].fetch(:content))
      _(result.creates[0].regions).must_equal(["global"])
      _(result.creates[1].id).must_equal(67623410)
      _(result.updates[0].id).must_equal(67622534)
      _(result.updates[0].type).must_equal("A")
      _(result.updates[0].name).must_equal(attributes.fetch(:updates)[0].fetch(:name))
      _(result.updates[0].content).must_equal(attributes.fetch(:updates)[0].fetch(:content))
      _(result.updates[1].id).must_equal(67622537)
      _(result.deletes[0].id).must_equal(67622509)
      _(result.deletes[1].id).must_equal(67622527)
    end

    describe "when there are errors with creation" do
      it "raises RequestError" do
        stub_request(:post, %r{/v2/#{account_id}/zones/#{zone_id}/batch$})
            .to_return(read_http_fixture("batchChangeZoneRecords/error_400_create_validation_failed.http"))

        error = _ {
          subject.batch_change_zone_records(account_id, zone_id, attributes)
        }.must_raise(Dnsimple::RequestError)
        _(error.message).must_equal("Validation failed")
        _(error.attribute_errors["creates"][0]["message"]).must_equal("Validation failed")
        _(error.attribute_errors["creates"][0]["index"]).must_equal(0)
        _(error.attribute_errors["creates"][0]["errors"]).must_equal({ "record_type" => ["unsupported"] })
      end
    end

    describe "when there are errors with updates" do
      it "raises RequestError" do
        stub_request(:post, %r{/v2/#{account_id}/zones/#{zone_id}/batch$})
            .to_return(read_http_fixture("batchChangeZoneRecords/error_400_update_validation_failed.http"))

        error = _ {
          subject.batch_change_zone_records(account_id, zone_id, attributes)
        }.must_raise(Dnsimple::RequestError)
        _(error.message).must_equal("Validation failed")
        _(error.attribute_errors["updates"][0]["message"]).must_equal("Record not found ID=99999999")
        _(error.attribute_errors["updates"][0]["index"]).must_equal(0)
      end
    end

    describe "when there are errors with deletes" do
      it "raises RequestError" do
        stub_request(:post, %r{/v2/#{account_id}/zones/#{zone_id}/batch$})
            .to_return(read_http_fixture("batchChangeZoneRecords/error_400_delete_validation_failed.http"))

        error = _ {
          subject.batch_change_zone_records(account_id, zone_id, attributes)
        }.must_raise(Dnsimple::RequestError)
        _(error.message).must_equal("Validation failed")
        _(error.attribute_errors["deletes"][0]["message"]).must_equal("Record not found ID=67622509")
        _(error.attribute_errors["deletes"][0]["index"]).must_equal(0)
      end
    end

    describe "when the zone does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-zone.http"))

        _ {
          subject.batch_change_zone_records(account_id, zone_id, attributes)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

end
