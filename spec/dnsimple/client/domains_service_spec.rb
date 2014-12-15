require 'spec_helper'

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").domains }


  describe "#list" do
    before do
      stub_request(:get, %r[/v1/domains$]).
          to_return(read_fixture("domains/index/success.http"))
    end

    it "builds the correct request" do
      subject.list

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domains" do
      results = subject.list

      expect(results).to be_a(Array)
      expect(results.size).to eq(2)

      result = results[0]
      expect(result.id).to eq(1)
      result = results[1]
      expect(result.id).to eq(2)
    end
  end

  describe "#create" do
    before do
      stub_request(:post, %r[/v1/domains]).
          to_return(read_fixture("domains/create/created.http"))
    end

    let(:attributes) { { name: "example.com" } }

    it "builds the correct request" do
      subject.create(attributes)

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains").
                             with(body: { domain: attributes }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.create(attributes)

      expect(result).to be_a(Dnsimple::Domain)
      expect(result.id).to eq(1)
    end
  end

  describe "#find" do
    before do
      stub_request(:get, %r[/v1/domains/.+$]).
          to_return(read_fixture("domains/show/success.http"))
    end

    it "builds the correct request" do
      subject.find("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.find("example.com")

      expect(result).to be_a(Dnsimple::Domain)
      expect(result.id).to eq(1)
      expect(result.user_id).to eq(21)
      expect(result.registrant_id).to eq(321)
      expect(result.name).to eq("example.com")
      expect(result.state).to eq("registered")
      expect(result.auto_renew).to eq(true)
      expect(result.whois_protected).to eq(false)
      expect(result.expires_on).to eq("2015-09-27")
      expect(result.created_at).to eq("2012-09-27T14:25:57.646Z")
      expect(result.updated_at).to eq("2014-12-15T20:27:04.552Z")
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("domains/notfound.http"))

        expect {
          subject.find("example.com")
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe "#delete" do
    before do
      stub_request(:delete, %r[/v1/domains/.+$]).
          to_return(read_fixture("domains/delete/success.http"))
    end

    it "builds the correct request" do
      subject.delete("example.com")

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/domains/example.com").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.delete("example.com")

      expect(result).to be_truthy
    end

    it "supports HTTP 204" do
      stub_request(:delete, %r[/v1]).
          to_return(read_fixture("contacts/delete/success-204.http"))

      result = subject.delete("example.com")

      expect(result).to be_truthy
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("domains/notfound.http"))

        expect {
          subject.delete("example.com")
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end


  describe "#enable_auto_renewal" do
    before do
      stub_request(:post, %r[/v1/domains/.+/auto_renewal]).
          to_return(read_fixture("domains/autorenewal/enable/success.http"))
    end

    it "builds the correct request" do
      subject.enable_auto_renewal("example.com")

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/example.com/auto_renewal").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.enable_auto_renewal("example.com")

      expect(result).to be_a(Dnsimple::Domain)
      expect(result.id).to eq(1)
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("domains/notfound.http"))

        expect {
          subject.enable_auto_renewal("example.com")
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe "#disable_auto_renewal" do
    before do
      stub_request(:delete, %r[/v1/domains/.+/auto_renewal]).
          to_return(read_fixture("domains/autorenewal/disable/success.http"))
    end

    it "builds the correct request" do
      subject.disable_auto_renewal("example.com")

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/domains/example.com/auto_renewal").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.disable_auto_renewal("example.com")

      expect(result).to be_a(Dnsimple::Domain)
      expect(result.id).to eq(1)
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("domains/notfound.http"))

        expect {
          subject.disable_auto_renewal("example.com")
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end


  describe "#check" do
    before do
      stub_request(:get, %r[/v1/domains/.+/check$]).
          to_return(read_fixture("domains/check/registered.http"))
    end

    it "builds the correct request" do
      subject.check("example.com")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/domains/example.com/check").
                             with(headers: { 'Accept' => 'application/json' })
    end

    context "the domain is registered" do
      before do
        stub_request(:get, %r[/v1/domains/.+/check$]).
            to_return(read_fixture("domains/check/registered.http"))
      end

      it "returns available" do
        expect(subject.check("example.com")).to eq("registered")
      end
    end

    context "the domain is available" do
      before do
        stub_request(:get, %r[/v1/domains/.+/check$]).
            to_return(read_fixture("domains/check/available.http"))
      end

      it "returns available" do
        expect(subject.check("example.com")).to eq("available")
      end
    end
  end

end
