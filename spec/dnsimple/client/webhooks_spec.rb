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

  describe "#webhook" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r[/v2/#{account_id}/webhooks/.+$])
          .to_return(read_http_fixture("getWebhook/success.http"))
    end

    it "builds the correct request" do
      subject.webhook(account_id, webhook = 1)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/webhooks/#{webhook}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the webhook" do
      response = subject.webhook(account_id, 0)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::Webhook)
      expect(result.id).to  eq(1)
      expect(result.url).to eq("https://webhook.test")
    end

    context "when the webhook does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v2])
            .to_return(read_http_fixture("notfound-webhook.http"))

        expect {
          subject.webhook(account_id, 0)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_webhook" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r[/v2/#{account_id}/webhooks/.+$])
          .to_return(read_http_fixture("deleteWebhook/success.http"))
    end

    it "builds the correct request" do
      subject.delete_webhook(account_id, contact_id = "1")

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/webhooks/#{contact_id}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      response = subject.delete_webhook(account_id, 1)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end

    context "when the webhook does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r[/v2])
            .to_return(read_http_fixture("notfound-webhook.http"))

        expect {
          subject.delete_webhook(account_id, 0)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
