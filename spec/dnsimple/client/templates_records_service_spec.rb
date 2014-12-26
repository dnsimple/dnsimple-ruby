require 'spec_helper'

describe Dnsimple::Client, ".templates / records" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").templates }


  describe "#list_records" do
    before do
      stub_request(:get, %r[/v1/templates/.+/records$]).
          to_return(read_fixture("templates_records/index/success.http"))
    end

    it "builds the correct request" do
      subject.list_records(1)

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/templates/1/records").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the template records" do
      results = subject.list_records(1)

      expect(results).to be_a(Array)
      expect(results.size).to eq(2)

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::TemplateRecord)
        expect(result.id).to be_a(Fixnum)
      end
    end
  end

  describe "#create_record" do
    before do
      stub_request(:post, %r[/v1/templates/.+/records$]).
          to_return(read_fixture("templates_records/create/created.http"))
    end

    it "builds the correct request" do
      subject.create_record(1, { name: "", record_type: "A", content: "127.0.0.1", prio: "1" })

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/templates/1/records").
                             with(body: { dns_template_record: { name: "", record_type: "A", content: "127.0.0.1", prio: "1" } }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the template record" do
      result = subject.create_record(1, { name: "", record_type: "", content: "" })

      expect(result).to be_a(Dnsimple::Struct::TemplateRecord)
      expect(result.id).to be_a(Fixnum)
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("templates_records/notfound.http"))

        expect {
          subject.create_record(1, { name: "", record_type: "", content: "" })
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe "#find_record" do
    before do
      stub_request(:get, %r[/v1/templates/.+/records/.+$]).
          to_return(read_fixture("templates_records/show/success.http"))
    end

    it "builds the correct request" do
      subject.find_record(1, 2)

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/templates/1/records/2").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      result = subject.find_record(1, 2)

      expect(result).to be_a(Dnsimple::Struct::TemplateRecord)
      expect(result.id).to eq(8868)
      expect(result.dns_template_id).to eq(2947)
      expect(result.name).to eq("ww1")
      expect(result.content).to eq("127.0.0.1")
      expect(result.ttl).to eq(3600)
      expect(result.prio).to be_nil
      expect(result.record_type).to eq("ALIAS")
      expect(result.created_at).to eq("2014-12-15T17:25:20.431Z")
      expect(result.updated_at).to eq("2014-12-15T17:25:20.431Z")
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("templates_records/notfound.http"))

        expect {
          subject.find_record(1, 2)
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe "#update_record" do
    before do
      stub_request(:put, %r[/v1/templates/.+/records/.+$]).
          to_return(read_fixture("templates_records/update/success.http"))
    end

    it "builds the correct request" do
      subject.update_record(1, 2, { name: "www" })

      expect(WebMock).to have_requested(:put, "https://api.zone/v1/templates/1/records/2").
                             with(body: { dns_template_record: { name: "www" } }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the template record" do
      result = subject.update_record(1, 2, {})

      expect(result).to be_a(Dnsimple::Struct::TemplateRecord)
      expect(result.id).to be_a(Fixnum)
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:put, %r[/v1]).
            to_return(read_fixture("templates_records/notfound.http"))

        expect {
          subject.update_record(1, 2, {})
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe "#delete_record" do
    before do
      stub_request(:delete, %r[/v1/templates/.+/records/.+$]).
          to_return(read_fixture("templates_records/delete/success.http"))
    end

    it "builds the correct request" do
      subject.delete_record(1, 2)

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/templates/1/records/2").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.delete_record(1, 2)

      expect(result).to be_truthy
    end

    it "supports HTTP 204" do
      stub_request(:delete, %r[/v1]).
          to_return(read_fixture("templates_records/delete/success-204.http"))

      result = subject.delete_record(1, 2)

      expect(result).to be_truthy
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("templates_records/notfound.http"))

        expect {
          subject.delete_record(1, 2)
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

end
