require 'spec_helper'

describe Dnsimple::Client, ".domains / records" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").domains }


  describe "#list_records" do
    before do
      stub_request(:get, %r[/v1/domains/.+/records$]).
          to_return(read_fixture("domains_records/index/success.http"))
    end

    it "builds the correct request" do
      subject.list_records("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/records").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the records" do
      results = subject.list_records("example.com")

      expect(results).to be_a(Array)
      expect(results.size).to eq(7)

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Record)
        expect(result.id).to be_a(Fixnum)
      end
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("domains_records/notfound.http"))

        expect {
          subject.list_records("example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#create_record" do
    before do
      stub_request(:post, %r[/v1/domains/.+/records$]).
          to_return(read_fixture("domains_records/create/created.http"))
    end

    it "builds the correct request" do
      subject.create_record("example.com", { name: "", record_type: "A", content: "127.0.0.1", prio: "1" })

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/example.com/records").
                             with(body: { record: { name: "", record_type: "A", content: "127.0.0.1", prio: "1" } }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      result = subject.create_record("example.com", { name: "", record_type: "", content: "" })

      expect(result).to be_a(Dnsimple::Struct::Record)
      expect(result.id).to be_a(Fixnum)
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("domains/notfound.http"))

        expect {
          subject.create_record("example.com", { name: "", record_type: "", content: "" })
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#find_record" do
    before do
      stub_request(:get, %r[/v1/domains/.+/records/.+$]).
          to_return(read_fixture("domains_records/show/success.http"))
    end

    it "builds the correct request" do
      subject.find_record("example.com", 2)

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/records/2").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      result = subject.find_record("example.com", 2)

      expect(result).to be_a(Dnsimple::Struct::Record)
      expect(result.id).to eq(1495)
      expect(result.domain_id).to eq(6)
      expect(result.name).to eq("www")
      expect(result.content).to eq("1.2.3.4")
      expect(result.ttl).to eq(3600)
      expect(result.prio).to be_nil
      expect(result.record_type).to eq("A")
      expect(result.created_at).to eq("2014-01-14T18:25:56Z")
      expect(result.updated_at).to eq("2014-01-14T18:26:04Z")
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("domains_records/notfound.http"))

        expect {
          subject.find_record("example.com", 2)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#update_record" do
    before do
      stub_request(:put, %r[/v1/domains/.+/records/.+$]).
          to_return(read_fixture("domains_records/update/success.http"))
    end

    it "builds the correct request" do
      subject.update_record("example.com", 2, { content: "127.0.0.1", prio: "1" })

      expect(WebMock).to have_requested(:put, "https://api.zone/v1/domains/example.com/records/2").
                             with(body: { record: { content: "127.0.0.1", prio: "1" } }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      result = subject.update_record("example.com", 2, {})

      expect(result).to be_a(Dnsimple::Struct::Record)
      expect(result.id).to be_a(Fixnum)
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:put, %r[/v1]).
            to_return(read_fixture("domains_records/notfound.http"))

        expect {
          subject.update_record("example.com", 2, {})
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_record" do
    before do
      stub_request(:delete, %r[/v1/domains/.+/records/.+$]).
          to_return(read_fixture("domains/delete/success.http"))
    end

    it "builds the correct request" do
      subject.delete_record("example.com", 2)

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/domains/example.com/records/2").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.delete_record("example.com", 2)

      expect(result).to be_truthy
    end

    it "supports HTTP 204" do
      stub_request(:delete, %r[/v1]).
          to_return(read_fixture("domains_records/delete/success-204.http"))

      result = subject.delete_record("example.com", 2)

      expect(result).to be_truthy
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("domains_records/notfound.http"))

        expect {
          subject.delete_record("example.com", 2)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
