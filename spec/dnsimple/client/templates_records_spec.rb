require 'spec_helper'

describe Dnsimple::Client, ".templates" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").templates }


  describe "#list_records" do
    let(:account_id) { 1010 }
    let(:template_id) { "alpha" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/templates/#{template_id}/records}).
          to_return(read_http_fixture("listTemplateRecords/success.http"))
    end

    it "builds the correct request" do
      subject.records(account_id, template_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records").
          with(headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.records(account_id, template_id, page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records?page=2")
    end

    it "supports extra request options" do
      subject.records(account_id, template_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records?foo=bar")
    end

    it "supports sorting" do
      subject.records(account_id, template_id, sort: "type:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records?sort=type:asc")
    end

    it "returns the list of template's records" do
      response = subject.records(account_id, template_id)
      expect(response).to be_a(Dnsimple::PaginatedResponse)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::TemplateRecord)
        expect(result.id).to be_a(Integer)
        expect(result.type).to be_a(String)
        expect(result.name).to be_a(String)
        expect(result.content).to be_a(String)
      end
    end
  end

  describe "#all_templates" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/templates/#{template_id}/records}).
          to_return(read_http_fixture("listTemplateRecords/success.http"))
    end

    let(:account_id) { 1010 }
    let(:template_id) { "alpha" }

    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:records, account_id, template_id, option: "value")
      subject.all_records(account_id, template_id, option: "value")
    end

    it "supports sorting" do
      subject.all_records(account_id, template_id, sort: "type:asc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records?page=1&per_page=100&sort=type:asc")
    end
  end

  describe "#create_record" do
    let(:account_id) { 1010 }
    let(:template_id) { "alpha" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/templates/#{template_id}/records$}).
          to_return(read_http_fixture("createTemplateRecord/created.http"))
    end

    let(:attributes) { { type: "MX", name: "", content: "mx.example.com", priority: 10, ttl: 600 } }

    it "builds the correct request" do
      subject.create_record(account_id, template_id, attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records").
          with(body: attributes).
          with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      response = subject.create_record(account_id, template_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::TemplateRecord)
      expect(result.id).to eq(300)
      expect(result.template_id).to eq(268)
      expect(result.name).to eq("")
      expect(result.type).to eq("MX")
      expect(result.content).to eq("mx.example.com")
      expect(result.ttl).to eq(600)
      expect(result.priority).to eq(10)
      expect(result.created_at).to eq("2016-05-03T07:51:33.202Z")
      expect(result.updated_at).to eq("2016-05-03T07:51:33.202Z")
    end

    context "with missing data" do
      it "raises an error when the type is missing" do
        expect {
          subject.create_record(account_id, template_id, name: "", content: "192.168.1.1")
        }.to raise_error(ArgumentError)
      end

      it "raises an error when the name is missing" do
        expect {
          subject.create_record(account_id, template_id, type: "A", content: "192.168.1.1")
        }.to raise_error(ArgumentError)
      end

      it "raises an error when the content is missing" do
        expect {
          subject.create_record(account_id, template_id, type: "A", name: "")
        }.to raise_error(ArgumentError)
      end
    end

    context "when the template does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2}).
            to_return(read_http_fixture("notfound-template.http"))

        expect {
          subject.create_record(account_id, template_id, attributes)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#record" do
    let(:account_id) { 1010 }
    let(:template_id) { "alpha.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/templates/#{template_id}/records/.+$}).
          to_return(read_http_fixture("getTemplateRecord/success.http"))
    end

    it "builds the correct request" do
      subject.record(account_id, template_id, record_id = 301)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records/#{record_id}").
          with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      response = subject.record(account_id, template_id, 301)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::TemplateRecord)
      expect(result.id).to eq(301)
      expect(result.template_id).to eq(268)
      expect(result.type).to eq("MX")
      expect(result.name).to eq("")
      expect(result.content).to eq("mx.example.com")
      expect(result.ttl).to eq(600)
      expect(result.priority).to eq(10)
      expect(result.created_at).to eq("2016-05-03T08:03:26.444Z")
      expect(result.updated_at).to eq("2016-05-03T08:03:26.444Z")
    end
  end

  describe "#delete_record" do
    let(:account_id) { 1010 }
    let(:template_id) { "example.com" }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/templates/#{template_id}/records/.+$}).
          to_return(read_http_fixture("deleteTemplateRecord/success.http"))
    end

    it "builds the correct request" do
      subject.delete_record(account_id, template_id, record_id = 301)

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}/records/#{record_id}").
          with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      response = subject.delete_record(account_id, template_id, 301)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end

    context "when the template does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2}).
            to_return(read_http_fixture("notfound-template.http"))

        expect {
          subject.delete_record(account_id, template_id, 0)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end

    context "when the record does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2}).
            to_return(read_http_fixture("notfound-record.http"))

        expect {
          subject.delete_record(account_id, template_id, 0)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
