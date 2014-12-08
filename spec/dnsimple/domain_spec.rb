require 'spec_helper'

describe DNSimple::Domain do

  let(:contact_id) { 1001 }

  describe ".find" do
    before do
      stub_request(:get, %r[/v1/domains/example.com]).
          to_return(read_fixture("domains/show/success.http"))
    end

    it "builds the correct request" do
      described_class.find("example.com")

      expect(WebMock).to have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/domains/example.com").
          with(:headers => { 'Accept' => 'application/json' })
    end

    context "when the domain exists" do
      it "returns the domain" do
        result = described_class.find("example.com")

        expect(result).to be_a(described_class)
        expect(result.id).to eq(6)
        expect(result.name).to eq("test-1383931357.com")
        expect(result.expires_on).to eq('2015-11-08')
        expect(result.created_at).to eq("2013-11-08T17:22:48Z")
        expect(result.updated_at).to eq("2014-01-14T18:27:04Z")
        expect(result.state).to eq("registered")
        expect(result.registrant_id).to eq(2)
        expect(result.user_id).to eq(2)
        expect(result.lockable).to eq(true)
        expect(result.auto_renew).to eq(true)
        expect(result.whois_protected).to eq(false)

        expect(result.name_server_status).to be_nil
      end
    end
  end

  describe "#enable_auto_renew" do
    let(:domain) { described_class.new(:name => 'example.com', :auto_renew => false) }

    context "when response is not 200" do
      before do
        stub_request(:post, %r[/v1/domains/example.com/auto_renewal]).
            to_return(read_fixture("domains/auto_renewal_enable/notfound.http"))
      end

      it "raises a RequestError" do
        expect { domain.enable_auto_renew }.to raise_error(DNSimple::RequestError)
      end
    end

    context "when auto_renew is true" do
      let(:domain) { described_class.new(:name => 'example.com', :auto_renew => true) }

      it "does not send a web request" do
        domain.enable_auto_renew
        expect(WebMock).to have_not_been_made
      end
    end

    context "when auto_renew is false" do
      let(:domain) { described_class.new(:name => 'example.com', :auto_renew => false) }

      before do
        stub_request(:post, %r[/v1/domains/example.com/auto_renewal]).
            to_return(read_fixture("domains/auto_renewal_enable/success.http"))
      end

      it "builds the correct request to enable auto_renew" do
        domain.enable_auto_renew

        expect(WebMock).to have_requested(:post, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/domains/example.com/auto_renewal").
            with(:headers => { 'Accept' => 'application/json' })
      end

      it "sets auto_renew to true on the domain" do
        domain.enable_auto_renew
        expect(domain.auto_renew).to be_truthy
      end
    end

  end

  describe "#disable_auto_renew" do
    let(:domain) { described_class.new(:name => 'example.com', :auto_renew => true) }

    context "when response is not 200" do
      before do
        stub_request(:delete, %r[/v1/domains/example.com/auto_renewal]).
            to_return(read_fixture("domains/auto_renewal_disable/notfound.http"))
      end

      it "raises a RequestError" do
        expect { domain.disable_auto_renew }.to raise_error(DNSimple::RequestError)
      end
    end

    context "when auto_renew is false" do
      let(:domain) { described_class.new(:name => 'example.com', :auto_renew => false) }

      it "does not send a web request" do
        domain.disable_auto_renew
        expect(WebMock).to have_not_been_made
      end
    end

    context "when auto_renew is true" do
      let(:domain) { described_class.new(:name => 'example.com', :auto_renew => true) }

      before do
        stub_request(:delete, %r[/v1/domains/example.com/auto_renewal]).
            to_return(read_fixture("domains/auto_renewal_disable/success.http"))
      end

      it "builds the correct request to disable auto_renew" do
        domain.disable_auto_renew

        expect(WebMock).to have_requested(:delete, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/domains/example.com/auto_renewal").
            with(:headers => { 'Accept' => 'application/json' })
      end

      it "sets auto_renew to false on the domain" do
        domain.disable_auto_renew
        expect(domain.auto_renew).to be_falsey
      end
    end

  end

  describe "#name_servers" do
    let(:domain) { described_class.new(:name => 'example.com') }

    context "when response is not 200" do
      let(:response) { read_fixture("domains/name_servers/notfound.http") }

      before do
        stub_request(:get, %r[/v1/domains/example.com/name_servers]).to_return(response)
      end

      it "raises a RequestError" do
        expect { domain.name_servers }.to raise_error(DNSimple::RequestError)
      end
    end

    context "when response is 200" do
      let(:response) { read_fixture("domains/name_servers/success.http") }

      before do
        stub_request(:get, %r[/v1/domains/example.com/name_servers]).to_return(response)
      end

      it "returns an array of nameservers" do
        expect(domain.name_servers).to eq(%w(ns1 ns2 ns3 ns4).map{|name| "#{name}.dnsimple.com" })
      end

    end

  end

end
