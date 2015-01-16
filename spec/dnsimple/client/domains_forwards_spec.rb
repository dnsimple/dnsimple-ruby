require 'spec_helper'

describe Dnsimple::Client, ".domains / forwards" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").domains }


  describe "#list_email_forwards" do
    before do
      stub_request(:get, %r[/v1/domains/.+/email_forwards]).
          to_return(read_fixture("domains_forwards/list/success.http"))
    end

    it "builds the correct request" do
      subject.list_email_forwards("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/email_forwards").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the records" do
      results = subject.list_email_forwards("example.com")

      expect(results).to be_a(Array)
      expect(results.size).to eq(2)

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::EmailForward)
        expect(result.id).to be_a(Fixnum)
      end
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("domains_forwards/notfound-domain.http"))

        expect {
          subject.list_email_forwards("example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#create_email_forward" do
    before do
      stub_request(:post, %r[/v1/domains/.+/email_forwards$]).
          to_return(read_fixture("domains_forwards/create/created.http"))
    end

    it "builds the correct request" do
      subject.create_email_forward("example.com", { from: "john", to: "someone@example.com" })

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/example.com/email_forwards").
                             with(body: { email_forward: { from: "john", to: "someone@example.com" } }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      result = subject.create_email_forward("example.com", { from: "", to: "" })

      expect(result).to be_a(Dnsimple::Struct::EmailForward)
      expect(result.id).to be_a(Fixnum)
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("domains_forwards/notfound-domain.http"))

        expect {
          subject.create_email_forward("example.com", { from: "", to: "" })
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#find_email_forward" do
    before do
      stub_request(:get, %r[/v1/domains/.+/email_forwards/.+$]).
          to_return(read_fixture("domains_forwards/get/success.http"))
    end

    it "builds the correct request" do
      subject.find_email_forward("example.com", 2)

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/email_forwards/2").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      result = subject.find_email_forward("example.com", 2)

      expect(result).to be_a(Dnsimple::Struct::EmailForward)
      expect(result.id).to eq(1)
      expect(result.domain_id).to eq(1111)
      expect(result.from).to eq("sender@dnsimple-sandbox.com")
      expect(result.to).to eq("receiver@example.com")
      expect(result.created_at).to eq("2014-12-16T12:55:13.697Z")
      expect(result.updated_at).to eq("2014-12-16T12:55:13.697Z")
    end

    context "when forward does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("domains_forwards/notfound.http"))

        expect {
          subject.find_email_forward("example.com", 2)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_email_forward" do
    before do
      stub_request(:delete, %r[/v1/domains/.+/email_forwards/.+$]).
          to_return(read_fixture("domains_forwards/delete/success.http"))
    end

    it "builds the correct request" do
      subject.delete_email_forward("example.com", 2)

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/domains/example.com/email_forwards/2").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.delete_email_forward("example.com", 2)

      expect(result).to be_truthy
    end

    context "when the forward does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("domains_forwards/notfound.http"))

        expect {
          subject.delete_email_forward("example.com", 2)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
