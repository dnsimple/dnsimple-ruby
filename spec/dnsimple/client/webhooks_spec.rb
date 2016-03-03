require 'spec_helper'

describe Dnsimple::Client, ".webhooks" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").webhooks }

  describe "#webhooks" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r[/v2/#{account_id}/webhooks])
          .to_return(read_http_fixture("listWebhooks/success.http"))
    end

    it "builds the correct request" do
      subject.webhooks(account_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/webhooks")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports extra request options" do
      subject.webhooks(account_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/webhooks?foo=bar")
    end

    it "returns the webhooks" do
      response = subject.webhooks(account_id)

      expect(response).to be_a(Dnsimple::CollectionResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Webhook)
        expect(result.id).to be_a(Fixnum)
      end
    end
  end

  describe "#all_webhooks" do
    let(:account_id) { 1010 }

    it "delegates to client.webhooks" do
      expect(subject).to receive(:webhooks).with(account_id, { foo: "bar" })
      subject.all_webhooks(account_id, { foo: "bar" })
    end
  end

  describe "#create_webhook" do
    let(:account_id) { 1010 }

    before do
      stub_request(:post, %r[/v2/#{account_id}/webhooks$])
          .to_return(read_http_fixture("createWebhook/created.http"))
    end

    let(:attributes) { {url: "https://webhook.test"} }

    it "builds the correct request" do
      subject.create_webhook(account_id, attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/webhooks")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the webhook" do
      response = subject.create_webhook(account_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Webhook)
      expect(result.id).to be_a(Fixnum)
    end
  end

end
