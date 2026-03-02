# frozen_string_literal: true

require "test_helper"

class WebhooksTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").webhooks
    @account_id = 1010
  end

  test "webhooks builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/webhooks})
        .to_return(read_http_fixture("listWebhooks/success.http"))

    @subject.webhooks(@account_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/webhooks",
                     headers: { "Accept" => "application/json" })
  end

  test "webhooks supports extra request options" do
    stub_request(:get, %r{/v2/#{@account_id}/webhooks})
        .to_return(read_http_fixture("listWebhooks/success.http"))

    @subject.webhooks(@account_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/webhooks?foo=bar")
  end

  test "webhooks supports sorting" do
    stub_request(:get, %r{/v2/#{@account_id}/webhooks})
        .to_return(read_http_fixture("listWebhooks/success.http"))

    @subject.webhooks(@account_id, sort: "id:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/webhooks?sort=id:asc")
  end

  test "webhooks returns the webhooks" do
    stub_request(:get, %r{/v2/#{@account_id}/webhooks})
        .to_return(read_http_fixture("listWebhooks/success.http"))

    response = @subject.webhooks(@account_id)

    assert_kind_of(Dnsimple::CollectionResponse, response)
    assert_kind_of(Array, response.data)
    assert_equal(2, response.data.size)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::Webhook, result)
      assert_kind_of(Integer, result.id)
    end
  end

  test "create webhook builds correct request" do
    stub_request(:post, %r{/v2/#{@account_id}/webhooks$})
        .to_return(read_http_fixture("createWebhook/created.http"))

    attributes = { url: "https://webhook.test" }
    @subject.create_webhook(@account_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/webhooks",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  test "create webhook returns the webhook" do
    stub_request(:post, %r{/v2/#{@account_id}/webhooks$})
        .to_return(read_http_fixture("createWebhook/created.http"))

    attributes = { url: "https://webhook.test" }
    response = @subject.create_webhook(@account_id, attributes)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Webhook, result)
    assert_kind_of(Integer, result.id)
  end

  test "webhook builds correct request" do
    stub_request(:get, %r{/v2/#{@account_id}/webhooks/.+$})
        .to_return(read_http_fixture("getWebhook/success.http"))

    webhook_id = "1"
    @subject.webhook(@account_id, webhook_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/webhooks/#{webhook_id}",
                     headers: { "Accept" => "application/json" })
  end

  test "webhook returns the webhook" do
    stub_request(:get, %r{/v2/#{@account_id}/webhooks/.+$})
        .to_return(read_http_fixture("getWebhook/success.http"))

    response = @subject.webhook(@account_id, 1)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_kind_of(Dnsimple::Struct::Webhook, result)
    assert_equal(1, result.id)
    assert_equal("https://webhook.test", result.url)
  end

  test "webhook when not found raises not found error" do
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-webhook.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.webhook(@account_id, 0)
    end
  end

  test "delete webhook builds correct request" do
    stub_request(:delete, %r{/v2/#{@account_id}/webhooks/.+$})
        .to_return(read_http_fixture("deleteWebhook/success.http"))

    webhook_id = "1"
    @subject.delete_webhook(@account_id, webhook_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/webhooks/#{webhook_id}",
                     headers: { "Accept" => "application/json" })
  end

  test "delete webhook returns nothing" do
    stub_request(:delete, %r{/v2/#{@account_id}/webhooks/.+$})
        .to_return(read_http_fixture("deleteWebhook/success.http"))

    response = @subject.delete_webhook(@account_id, 1)

    assert_kind_of(Dnsimple::Response, response)

    result = response.data

    assert_nil(result)
  end

  test "delete webhook when not found raises not found error" do
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-webhook.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.delete_webhook(@account_id, 0)
    end
  end
end
