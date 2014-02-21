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

      WebMock.should have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/domains/example.com").
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

        expect(result.name_server_status).to be_nil
      end
    end
  end

  describe "#enable_auto_renew" do

    context "when response is not 200" do

      let(:domain) { described_class.new 'name' => 'test1383931357.com' }
      before do
        stub_request(:post, %r[/v1/domains/test1383931357.com/auto_renewal]).
          to_return(read_fixture("domains/show/notfound.http"))
      end

      it "raises a RequestError" do
        expect { domain.enable_auto_renew }.to raise_error DNSimple::RequestError
      end
    end

    context "when auto_renew is true" do

      let(:domain) { described_class.new 'auto_renew' => true,
                                         'name' => 'example.com' }

      it "does not send a web request" do
        domain.enable_auto_renew
        WebMock.should_not have_requested(:post, %r[/v1/domains/example.com/auto_renewal])
      end

    end

    context "when auto_renew is false" do

      let(:domain) { described_class.new 'auto_renew' => false,
                                         'name' => 'example.com' }
      before do
        stub_request(:post, %r[/v1/domains/example.com/auto_renewal]).
          to_return(read_fixture("domains/show/success.http"))
      end

      it "builds the correct request to enable auto_renew" do
        domain.enable_auto_renew

        WebMock.should have_requested(:post, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/domains/example.com/auto_renewal").
          with(:headers => { 'Accept' => 'application/json' })
      end

      it "sets auto_renew to true on the domain" do
        domain.enable_auto_renew
        domain.auto_renew.should be_true
      end
    end

  end

  describe "#disable_auto_renew" do

    context "when response is not 200" do

      let(:domain) { described_class.new 'auto_renew' => true,
                                         'name' => 'test1383931357.com' }
      before do
        stub_request(:delete, %r[/v1/domains/test1383931357.com/auto_renewal]).
          to_return(read_fixture("domains/show/notfound.http"))
      end

      it "raises a RequestError" do
        expect { domain.disable_auto_renew }.to raise_error DNSimple::RequestError
      end
    end

    context "when auto_renew is true" do

      let(:domain) { described_class.new 'auto_renew' => true,
                                         'name' => 'example.com' }
      before do
        stub_request(:delete, %r[/v1/domains/example.com/auto_renewal]).
          to_return(read_fixture("domains/show/auto_renew_false.http"))
      end

      it "builds the correct request to disable auto_renew" do
        domain.disable_auto_renew

        WebMock.should have_requested(:delete, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/domains/example.com/auto_renewal").
          with(:headers => { 'Accept' => 'application/json' })
      end

      it "sets auto_renew to false on the domain" do
        domain.disable_auto_renew
        domain.auto_renew.should be_false
      end
    end

    context "when auto_renew is false" do
      let(:domain) { described_class.new 'auto_renew' => false,
                                         'name' => 'example.com' }

      it "does not send a web request" do
        domain.disable_auto_renew
        WebMock.should_not have_requested(:delete, %r[/v1/domains/example.com/auto_renewal])
      end
    end
  end
end
