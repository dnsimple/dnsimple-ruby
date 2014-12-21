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

      expect(result).to be_a(Dnsimple::Struct::Domain)
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

      expect(result).to be_a(Dnsimple::Struct::Domain)
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

      expect(result).to be_a(Dnsimple::Struct::Domain)
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

      expect(result).to be_a(Dnsimple::Struct::Domain)
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


  describe "#list_email_forwards" do
    before do
      stub_request(:get, %r[/v1/domains/.+/email_forwards]).
          to_return(read_fixture("domains/forwards/list/success.http"))
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

      result = results[0]
      expect(result.id).to eq(1)
      result = results[1]
      expect(result.id).to eq(2)
    end

    context "when the domain does not exist" do
      it "raises RecordNotFound" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("domains/forwards/notfound-domain.http"))

        expect {
          subject.list_email_forwards("example.com")
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe "#create_email_forward" do
    before do
      stub_request(:post, %r[/v1/domains/.+/email_forwards$]).
          to_return(read_fixture("domains/forwards/create/created.http"))
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
      expect(result.id).to eq(1)
    end

    context "when the domain does not exist" do
      it "raises RecordNotFound" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("domains/forwards/notfound-domain.http"))

        expect {
          subject.create_email_forward("example.com", { from: "", to: "" })
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe "#find_email_forward" do
    before do
      stub_request(:get, %r[/v1/domains/.+/email_forwards/.+$]).
          to_return(read_fixture("domains/forwards/get/success.http"))
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
      it "raises RecordNotFound" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("domains/forwards/notfound.http"))

        expect {
          subject.find_email_forward("example.com", 2)
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end

  describe "#delete_email_forwards" do
    before do
      stub_request(:delete, %r[/v1/domains/.+/email_forwards/.+$]).
          to_return(read_fixture("domains/forwards/delete/success.http"))
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
      it "raises RecordNotFound" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("domains/forwards/notfound.http"))

        expect {
          subject.delete_email_forward("example.com", 2)
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

  describe "#register" do
    before do
      stub_request(:post, %r[/v1/domain_registrations]).
          to_return(read_fixture("domains/registration/success.http"))
    end

    it "builds the correct request" do
      subject.register("example.com", 10)

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domain_registrations").
                             with(body: { domain: { name: "example.com", registrant_id: "10" }}).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.register("example.com", 10)

      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to eq(1797)
    end
  end

  describe "#renew" do
    before do
      stub_request(:post, %r[/v1/domain_renewals]).
          to_return(read_fixture("domains/renewal/success.http"))
    end

    it "builds the correct request" do
      subject.renew("example.com")

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domain_renewals").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain" do
      result = subject.renew("example.com")

      expect(result).to be_a(Dnsimple::Struct::Domain)
      expect(result.id).to eq(1797)
    end

    context "when something does not exist" do
      it "raises RecordNotFound" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("domains/notfound.http"))

        expect {
          subject.renew("example.com")
        }.to raise_error(Dnsimple::RecordNotFound)
      end
    end
  end


  describe "#extended_attributes" do
    before do
      stub_request(:get, %r[/v1/extended_attributes/.+$]).
          to_return(read_fixture("registrar/extended-attributes/list/success.http"))
    end

    it "builds the correct request" do
      subject.extended_attributes("uk")

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/extended_attributes/uk").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the extended attributes" do
      results = subject.extended_attributes("uk")

      expect(results).to be_a(Array)
      expect(results.size).to eq(4)

      result = results[0]
      expect(result).to be_a(Dnsimple::Struct::ExtendedAttribute)
      expect(result.name).to eq("uk_legal_type")
      expect(result.description).to eq("Legal type of registrant contact")
      expect(result.required).to eq(false)
      expect(result.options).to be_a(Array)
      expect(result.options.size).to eq(17)

      option = result.options[0]
      expect(option.title).to eq("UK Individual")
      expect(option.value).to eq("IND")
      expect(option.description).to eq("UK Individual (our default value)")
    end
  end

end
