# frozen_string_literal: true

require "test_helper"

class WebhooksTest < Minitest::Test

  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").webhooks
    @account_id = 1010
  end

  def test_webhooks_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/webhooks})
        .to_return(read_http_fixture("listWebhooks/success.http"))

    @subject.webhooks(@account_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/webhooks",
                     headers: { "Accept" => "application/json" })
  end

  def test_webhooks_supports_extra_request_options
    stub_request(:get, %r{/v2/#{@account_id}/webhooks})
        .to_return(read_http_fixture("listWebhooks/success.http"))

    @subject.webhooks(@account_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/webhooks?foo=bar")
  end

  def test_webhooks_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/webhooks})
        .to_return(read_http_fixture("listWebhooks/success.http"))

    @subject.webhooks(@account_id, sort: "id:asc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/webhooks?sort=id:asc")
  end

  def test_webhooks_returns_the_webhooks
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

  def test_create_webhook_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/webhooks$})
        .to_return(read_http_fixture("createWebhook/created.http"))

    attributes = { url: "https://webhook.test" }
    @subject.create_webhook(@account_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/webhooks",
                     body: attributes,
                     headers: { "Accept" => "application/json" })
  end

  def test_create_webhook_returns_the_webhook
    stub_request(:post, %r{/v2/#{@account_id}/webhooks$})
        .to_return(read_http_fixture("createWebhook/created.http"))

    attributes = { url: "https://webhook.test" }
    response = @subject.create_webhook(@account_id, attributes)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::Webhook, result)
    assert_kind_of(Integer, result.id)
  end

  def test_webhook_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/webhooks/.+$})
        .to_return(read_http_fixture("getWebhook/success.http"))

    webhook_id = "1"
    @subject.webhook(@account_id, webhook_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/webhooks/#{webhook_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_webhook_returns_the_webhook
    stub_request(:get, %r{/v2/#{@account_id}/webhooks/.+$})
        .to_return(read_http_fixture("getWebhook/success.http"))

    response = @subject.webhook(@account_id, 1)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_kind_of(Dnsimple::Struct::Webhook, result)
    assert_equal(1, result.id)
    assert_equal("https://webhook.test", result.url)
  end

  def test_webhook_when_not_found_raises_not_found_error
    stub_request(:get, %r{/v2})
        .to_return(read_http_fixture("notfound-webhook.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.webhook(@account_id, 0)
    end
  end

  def test_delete_webhook_builds_correct_request
    stub_request(:delete, %r{/v2/#{@account_id}/webhooks/.+$})
        .to_return(read_http_fixture("deleteWebhook/success.http"))

    webhook_id = "1"
    @subject.delete_webhook(@account_id, webhook_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/webhooks/#{webhook_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_delete_webhook_returns_nothing
    stub_request(:delete, %r{/v2/#{@account_id}/webhooks/.+$})
        .to_return(read_http_fixture("deleteWebhook/success.http"))

    response = @subject.delete_webhook(@account_id, 1)
    assert_kind_of(Dnsimple::Response, response)

    result = response.data
    assert_nil(result)
  end

  def test_delete_webhook_when_not_found_raises_not_found_error
    stub_request(:delete, %r{/v2})
        .to_return(read_http_fixture("notfound-webhook.http"))

    assert_raises(Dnsimple::NotFoundError) do
      @subject.delete_webhook(@account_id, 0)
    end
  end

end
