require 'spec_helper'

describe Dnsimple::Client, ".domains / sharing" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").domains }


  describe "#memberships" do
    before do
      stub_request(:get, %r[/v1/domains/.+/memberships$]).
          to_return(read_fixture("domains_sharing/list/success.http"))
    end

    it "builds the correct request" do
      subject.memberships("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/memberships").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the records" do
      results = subject.memberships("example.com")

      expect(results).to be_a(Array)
      expect(results.size).to eq(2)

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Membership)
        expect(result.id).to be_a(Fixnum)
      end
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("domains_sharing/notfound-domain.http"))

        expect {
          subject.memberships("example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#create_membership" do
    before do
      stub_request(:post, %r[/v1/domains/.+/memberships$]).
          to_return(read_fixture("domains_sharing/create/success.http"))
    end

    it "builds the correct request" do
      subject.create_membership("example.com", "someone@example.com")

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/example.com/memberships").
                             with(body: { membership: { email: "someone@example.com" } }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the record" do
      result = subject.create_membership("example.com", "someone@example.com")

      expect(result).to be_a(Dnsimple::Struct::Membership)
      expect(result.id).to be_a(Fixnum)
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("domains_forwards/notfound-domain.http"))

        expect {
          subject.create_membership("example.com", "someone@example.com")
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_membership" do
    before do
      stub_request(:delete, %r[/v1/domains/.+/memberships/.+$]).
          to_return(read_fixture("domains_sharing/delete/success.http"))
    end

    it "builds the correct request" do
      subject.delete_membership("example.com", 2)

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/domains/example.com/memberships/2").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.delete_membership("example.com", 2)

      expect(result).to be_truthy
    end

    context "when the membership does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("domains_sharing/notfound.http"))

        expect {
          subject.delete_membership("example.com", 2)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
