require 'spec_helper'

describe Dnsimple::Client, ".records" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").records }


  describe ".list" do
    before do
      stub_request(:get, %r[/v1/domains/.+/records$]).
          to_return(read_fixture("records/index/success.http"))
    end

    it "builds the correct request" do
      subject.list("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/records").
                         with { |req| req.headers['Accept'] == 'application/json' }
    end

    it "returns the records" do
      results = subject.list("example.com")

      expect(results).to be_a(Array)
      expect(results.size).to eq(7)

      result = results[0]
      expect(result.id).to eq(36)
      result = results[1]
      expect(result.id).to eq(37)
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("records/notfound.http"))

        expect {
          subject.list("example.com")
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe ".create" do
    before do
      stub_request(:post, %r[/v1/domains/.+/records$]).
          to_return(read_fixture("records/create/created.http"))
    end

    it "builds the correct request" do
      subject.create("example.com", { name: "", record_type: "A", content: "127.0.0.1", prio: "1" })

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/example.com/records").
                         with(body: { record: { name: "", record_type: "A", content: "127.0.0.1", prio: "1" } }).
                         with { |req| req.headers['Accept'] == 'application/json' }
    end

    it "returns the record" do
      result = subject.create("example.com", { name: "", record_type: "", content: "" })

      expect(result).to be_a(Dnsimple::Record)
      expect(result.id).to eq(3554751)
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("records/notfound.http"))

        expect {
          subject.create("example.com", { name: "", record_type: "", content: "" })
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe ".find" do
    before do
      stub_request(:get, %r[/v1/domains/.+/records/.+$]).
          to_return(read_fixture("records/show/success.http"))
    end

    it "builds the correct request" do
      subject.find("example.com", 2)

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/records/2").
                         with { |req| req.headers['Accept'] == 'application/json' }
    end

    it "returns the record" do
      result = subject.find("example.com", 2)

      expect(result).to be_a(Dnsimple::Record)
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
      it "raises RecordNotFound" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("records/notfound.http"))

        expect {
          subject.find("example.com", 2)
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe ".update" do
    before do
      stub_request(:put, %r[/v1/domains/.+/records/.+$]).
          to_return(read_fixture("records/update/success.http"))
    end

    it "builds the correct request" do
      subject.update("example.com", 2, { content: "127.0.0.1", prio: "1" })

      expect(WebMock).to have_requested(:put, "https://api.zone/v1/domains/example.com/records/2").
                             with(body: { record: { content: "127.0.0.1", prio: "1" } }).
                             with { |req| req.headers['Accept'] == 'application/json' }
    end

    it "returns the record" do
      result = subject.update("example.com", 2, {})

      expect(result).to be_a(Dnsimple::Record)
      expect(result.id).to eq(3554751)
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:put, %r[/v1]).
            to_return(read_fixture("records/notfound.http"))

        expect {
          subject.update("example.com", 2, {})
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe ".delete" do
    before do
      stub_request(:delete, %r[/v1/domains/example.com/records/2$]).
          to_return(read_fixture("domains/delete/success.http"))
    end

    it "builds the correct request" do
      subject.delete("example.com", "2")

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/domains/example.com/records/2").
                         with { |req| req.headers['Accept'] == 'application/json' }
    end

    it "returns nothing" do
      result = subject.delete("example.com", 2)

      expect(result).to be_truthy
    end

    it "supports HTTP 204" do
      stub_request(:delete, %r[/v1]).
          to_return(read_fixture("records/delete/success-204.http"))

      result = subject.delete("example.com", 2)

      expect(result).to be_truthy
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("records/notfound.http"))

        expect {
          subject.delete("example.com", 2)
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

end
