require 'spec_helper'

describe Dnsimple::Domain do

  describe "#enable_auto_renew" do
    let(:domain) { described_class.new(:name => 'example.com', :auto_renew => false) }

    context "when response is not 200" do
      before do
        stub_request(:post, %r[/v1/domains/example.com/auto_renewal]).
            to_return(read_fixture("domains/autorenewal/enable/notfound.http"))
      end

      it "raises a RequestError" do
        expect { domain.enable_auto_renew }.to raise_error(Dnsimple::RequestError)
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
            to_return(read_fixture("domains/autorenewal/enable/success.http"))
      end

      it "builds the correct request to enable auto_renew" do
        domain.enable_auto_renew

        expect(WebMock).to have_requested(:post, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/domains/example.com/auto_renewal").
            with(headers: { 'Accept' => 'application/json' })
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
            to_return(read_fixture("domains/autorenewal/disable/notfound.http"))
      end

      it "raises a RequestError" do
        expect { domain.disable_auto_renew }.to raise_error(Dnsimple::RequestError)
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
            to_return(read_fixture("domains/autorenewal/disable/success.http"))
      end

      it "builds the correct request to disable auto_renew" do
        domain.disable_auto_renew

        expect(WebMock).to have_requested(:delete, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/v1/domains/example.com/auto_renewal").
            with(headers: { 'Accept' => 'application/json' })
      end

      it "sets auto_renew to false on the domain" do
        domain.disable_auto_renew
        expect(domain.auto_renew).to be_falsey
      end
    end
  end

end
