# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".webhooks" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").webhooks }

  describe "#webhooks" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/webhooks})
          .to_return(read_http_fixture("listWebhooks/success.http"))
    end

    it "builds the correct request" do
      subject.webhooks(account_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/webhooks",
                       headers: { "Accept" => "application/json" })
    end

    it "supports extra request options" do
      subject.webhooks(account_id, query: { foo: "bar" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/webhooks?foo=bar")
    end

    it "supports sorting" do
      subject.webhooks(account_id, sort: "id:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/webhooks?sort=id:asc")
    end

    it "returns the webhooks" do
      response = subject.webhooks(account_id)

      _(response).must_be_kind_of(Dnsimple::CollectionResponse)
      _(response.data).must_be_kind_of(Array)
      _(response.data.size).must_equal(2)

      response.data.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::Webhook)
        _(result.id).must_be_kind_of(Integer)
      end
    end
  end

  describe "#create_webhook" do
    let(:account_id) { 1010 }
    let(:attributes) { { url: "https://webhook.test" } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/webhooks$})
          .to_return(read_http_fixture("createWebhook/created.http"))
    end


    it "builds the correct request" do
      subject.create_webhook(account_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/webhooks",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the webhook" do
      response = subject.create_webhook(account_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Webhook)
      _(result.id).must_be_kind_of(Integer)
    end
  end

  describe "#webhook" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/webhooks/.+$})
          .to_return(read_http_fixture("getWebhook/success.http"))
    end

    it "builds the correct request" do
      subject.webhook(account_id, webhook_id = "1")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/webhooks/#{webhook_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the webhook" do
      response = subject.webhook(account_id, 1)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Webhook)
      _(result.id).must_equal(1)
      _(result.url).must_equal("https://webhook.test")
    end

    describe "when the webhook does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-webhook.http"))

        _ {
          subject.webhook(account_id, 0)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_webhook" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/webhooks/.+$})
          .to_return(read_http_fixture("deleteWebhook/success.http"))
    end

    it "builds the correct request" do
      subject.delete_webhook(account_id, webhook_id = "1")

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/webhooks/#{webhook_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.delete_webhook(account_id, 1)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end

    describe "when the webhook does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-webhook.http"))

        _ {
          subject.delete_webhook(account_id, 0)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

end
