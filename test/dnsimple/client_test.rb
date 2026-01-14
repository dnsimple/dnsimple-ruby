# frozen_string_literal: true

require "test_helper"

class ClientTest < Minitest::Test

  def test_initialization_accepts_base_url_option
    subject = Dnsimple::Client.new(base_url: "https://api.example.com/")
    assert_equal "https://api.example.com/", subject.base_url
  end

  def test_initialization_accepts_access_token_option
    subject = Dnsimple::Client.new(access_token: "token")
    assert_equal "token", subject.access_token
  end

  def test_initialization_normalizes_base_url_trailing_slash
    subject = Dnsimple::Client.new(base_url: "https://api.example.com/missing/slash")
    assert_equal "https://api.example.com/missing/slash/", subject.base_url
  end

  def test_initialization_defaults_base_url_to_production_api
    subject = Dnsimple::Client.new
    assert_equal "https://api.dnsimple.com/", subject.base_url
  end

  def test_authentication_uses_http_authentication_if_password_provided
    stub_request(:any, %r{/test})

    subject = Dnsimple::Client.new(username: "user", password: "pass")
    subject.execute(:get, "test", {})

    assert_requested(:get, "https://api.dnsimple.com/test", basic_auth: %w[user pass])
  end

  def test_authentication_uses_access_token_if_provided
    stub_request(:any, %r{/test})

    subject = Dnsimple::Client.new(access_token: "access-token")
    subject.execute(:get, "test", {})

    assert_requested(:get, "https://api.dnsimple.com/test") { |req| req.headers["Authorization"] == "Bearer access-token" }
  end

  def test_get_delegates_to_execute
    subject = Dnsimple::Client.new
    mock = Minitest::Mock.new
    mock.expect(:call, :returned, [:get, "path", nil, { foo: "bar" }])
    subject.stub(:execute, mock) do
      assert_equal :returned, subject.get("path", { foo: "bar" })
    end
    mock.verify
  end

  def test_post_delegates_to_execute
    subject = Dnsimple::Client.new
    mock = Minitest::Mock.new
    mock.expect(:call, :returned, [:post, "path", { foo: "bar" }, {}])
    subject.stub(:execute, mock) do
      assert_equal :returned, subject.post("path", { foo: "bar" })
    end
    mock.verify
  end

  def test_put_delegates_to_execute
    subject = Dnsimple::Client.new
    mock = Minitest::Mock.new
    mock.expect(:call, :returned, [:put, "path", { foo: "bar" }, {}])
    subject.stub(:execute, mock) do
      assert_equal :returned, subject.put("path", { foo: "bar" })
    end
    mock.verify
  end

  def test_patch_delegates_to_execute
    subject = Dnsimple::Client.new
    mock = Minitest::Mock.new
    mock.expect(:call, :returned, [:patch, "path", { foo: "bar" }, {}])
    subject.stub(:execute, mock) do
      assert_equal :returned, subject.patch("path", { foo: "bar" })
    end
    mock.verify
  end

  def test_delete_delegates_to_execute
    subject = Dnsimple::Client.new
    mock = Minitest::Mock.new
    mock.expect(:call, :returned, [:delete, "path", { foo: "bar" }, {}])
    subject.stub(:execute, mock) do
      assert_equal :returned, subject.delete("path", { foo: "bar" })
    end
    mock.verify
  end

  def test_execute_raises_request_error_for_json_error_response
    stub_request(:post, %r{/foo}).to_return(read_http_fixture("transferDomain/error-indnsimple.http"))

    subject = Dnsimple::Client.new(username: "user", password: "pass")
    error = assert_raises(Dnsimple::RequestError) do
      subject.execute(:post, "foo", {})
    end
    assert_equal "The domain google.com is already in DNSimple and cannot be added", error.message
    assert_nil error.attribute_errors
  end

  def test_execute_raises_request_error_with_attribute_errors
    stub_request(:post, %r{/foo}).to_return(read_http_fixture("validation-error.http"))

    subject = Dnsimple::Client.new(username: "user", password: "pass")
    error = assert_raises(Dnsimple::RequestError) do
      subject.execute(:post, "foo", {})
    end
    assert_equal "Validation failed", error.message
    assert_respond_to error, :attribute_errors
    assert_kind_of Hash, error.attribute_errors
    assert_equal ["can't be blank", "is an invalid email address"], error.attribute_errors["email"]
    assert_equal ["can't be blank"], error.attribute_errors["address1"]
  end

  def test_execute_raises_request_error_for_html_error_response
    stub_request(:get, %r{/foo}).to_return(read_http_fixture("badgateway.http"))

    subject = Dnsimple::Client.new(username: "user", password: "pass")
    error = assert_raises(Dnsimple::RequestError) do
      subject.execute(:get, "foo", {})
    end
    assert_equal "502 Bad Gateway", error.message
    assert_nil error.attribute_errors
  end

  def test_execute_raises_request_error_in_absence_of_content_types
    stub_request(:put, %r{/foo}).to_return(read_http_fixture("method-not-allowed.http"))

    subject = Dnsimple::Client.new(username: "user", password: "pass")
    error = assert_raises(Dnsimple::RequestError) do
      subject.execute(:put, "foo", {})
    end
    assert_equal "405 Method Not Allowed", error.message
    assert_nil error.attribute_errors
  end

  def test_request_performs_a_request
    stub_request(:get, %r{/foo})

    subject = Dnsimple::Client.new(username: "user", password: "pass")
    subject.request(:get, "foo", {})

    assert_requested(:get, "https://api.dnsimple.com/foo",
                     headers: { "Accept" => "application/json", "User-Agent" => Dnsimple::Default::USER_AGENT },
                     basic_auth: %w[user pass])
  end

  def test_request_delegates_to_httparty
    stub_request(:get, %r{/foo})

    subject = Dnsimple::Client.new(username: "user", password: "pass")
    subject.request(:get, "foo")

    assert_requested(:get, "https://api.dnsimple.com/foo")
  end

  def test_request_extracts_options_and_encodes_data
    stub_request(:put, %r{/foo})

    subject = Dnsimple::Client.new(username: "user", password: "pass")
    subject.request(:put, "foo", { something: "else" }, { query: { foo: "bar" }, headers: { "Custom" => "Header" } })

    assert_requested(:put, "https://api.dnsimple.com/foo?foo=bar",
                     body: JSON.dump(something: "else"),
                     headers: { "Accept" => "application/json", "Content-Type" => "application/json", "User-Agent" => Dnsimple::Default::USER_AGENT, "Custom" => "Header" })
  end

  def test_request_handles_non_json_content_types
    stub_request(:post, %r{/foo})

    subject = Dnsimple::Client.new(username: "user", password: "pass")
    subject.request(:post, "foo", { something: "else" }, { headers: { "Content-Type" => "application/x-www-form-urlencoded" } })

    assert_requested(:post, "https://api.dnsimple.com/foo",
                     body: { something: "else" },
                     headers: { "Accept" => "application/json", "Content-Type" => "application/x-www-form-urlencoded", "User-Agent" => Dnsimple::Default::USER_AGENT })
  end

  def test_request_includes_options_for_proxy_support
    stub_request(:get, %r{/test})

    subject = Dnsimple::Client.new(proxy: "example-proxy.com:4321")
    subject.request(:get, "test", nil, {})

    assert_requested(:get, "https://api.dnsimple.com/test")
  end

  def test_request_supports_custom_user_agent
    stub_request(:get, %r{/test})

    subject = Dnsimple::Client.new(user_agent: "customAgent")
    subject.request(:get, "test", nil)

    assert_requested(:get, "https://api.dnsimple.com/test",
                     headers: { "User-Agent" => "customAgent #{Dnsimple::Default::USER_AGENT}" })
  end

end
