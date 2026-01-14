# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".templates" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").templates }


  describe "#list_records" do
    let(:account_id) { 1010 }
    let(:template_id) { "alpha" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/templates/#{template_id}/records})
          .to_return(read_http_fixture("listTemplateRecords/success.http"))
    end

    it "builds the correct request" do
      subject.records(account_id, template_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records",
                       headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.records(account_id, template_id, page: 2)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records?page=2")
    end

    it "supports extra request options" do
      subject.records(account_id, template_id, query: { foo: "bar" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records?foo=bar")
    end

    it "supports sorting" do
      subject.records(account_id, template_id, sort: "type:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records?sort=type:asc")
    end

    it "returns the list of template's records" do
      response = subject.records(account_id, template_id)
      _(response).must_be_kind_of(Dnsimple::PaginatedResponse)

      response.data.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::TemplateRecord)
        _(result.id).must_be_kind_of(Integer)
        _(result.type).must_be_kind_of(String)
        _(result.name).must_be_kind_of(String)
        _(result.content).must_be_kind_of(String)
      end
    end
  end

  describe "#all_templates" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/templates/#{template_id}/records})
          .to_return(read_http_fixture("listTemplateRecords/success.http"))
    end

    let(:account_id) { 1010 }
    let(:template_id) { "alpha" }

    it "delegates to client.paginate" do
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [:records, account_id, template_id, { option: "value" }])
      subject.stub(:paginate, mock) do
        subject.all_records(account_id, template_id, option: "value")
      end
      mock.verify
    end

    it "supports sorting" do
      subject.all_records(account_id, template_id, sort: "type:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records?page=1&per_page=100&sort=type:asc")
    end
  end

  describe "#create_record" do
    let(:account_id) { 1010 }
    let(:attributes) { { type: "MX", name: "", content: "mx.example.com", priority: 10, ttl: 600 } }
    let(:template_id) { "alpha" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/templates/#{template_id}/records$})
          .to_return(read_http_fixture("createTemplateRecord/created.http"))
    end


    it "builds the correct request" do
      subject.create_record(account_id, template_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the record" do
      response = subject.create_record(account_id, template_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::TemplateRecord)
      _(result.id).must_equal(300)
      _(result.template_id).must_equal(268)
      _(result.name).must_equal("")
      _(result.type).must_equal("MX")
      _(result.content).must_equal("mx.example.com")
      _(result.ttl).must_equal(600)
      _(result.priority).must_equal(10)
      _(result.created_at).must_equal("2016-05-03T07:51:33Z")
      _(result.updated_at).must_equal("2016-05-03T07:51:33Z")
    end

    describe "with missing data" do
      it "raises an error when the type is missing" do
        _ {
          subject.create_record(account_id, template_id, name: "", content: "192.168.1.1")
        }.must_raise(ArgumentError)
      end

      it "raises an error when the name is missing" do
        _ {
          subject.create_record(account_id, template_id, type: "A", content: "192.168.1.1")
        }.must_raise(ArgumentError)
      end

      it "raises an error when the content is missing" do
        _ {
          subject.create_record(account_id, template_id, type: "A", name: "")
        }.must_raise(ArgumentError)
      end
    end

    describe "when the template does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-template.http"))

        _ {
          subject.create_record(account_id, template_id, attributes)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#record" do
    let(:account_id) { 1010 }
    let(:template_id) { "alpha.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/templates/#{template_id}/records/.+$})
          .to_return(read_http_fixture("getTemplateRecord/success.http"))
    end

    it "builds the correct request" do
      subject.record(account_id, template_id, record_id = 301)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records/#{record_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the record" do
      response = subject.record(account_id, template_id, 301)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::TemplateRecord)
      _(result.id).must_equal(301)
      _(result.template_id).must_equal(268)
      _(result.type).must_equal("MX")
      _(result.name).must_equal("")
      _(result.content).must_equal("mx.example.com")
      _(result.ttl).must_equal(600)
      _(result.priority).must_equal(10)
      _(result.created_at).must_equal("2016-05-03T08:03:26Z")
      _(result.updated_at).must_equal("2016-05-03T08:03:26Z")
    end
  end

  describe "#delete_record" do
    let(:account_id) { 1010 }
    let(:template_id) { "example.com" }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/templates/#{template_id}/records/.+$})
          .to_return(read_http_fixture("deleteTemplateRecord/success.http"))
    end

    it "builds the correct request" do
      subject.delete_record(account_id, template_id, record_id = 301)

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records/#{record_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.delete_record(account_id, template_id, 301)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end

    describe "when the template does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-template.http"))

        _ {
          subject.delete_record(account_id, template_id, 0)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end

    describe "when the record does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-record.http"))

        _ {
          subject.delete_record(account_id, template_id, 0)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

end
