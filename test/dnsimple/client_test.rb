# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client do

  describe "initialization" do
    it "accepts :base_url option" do
      subject = Dnsimple::Client.new(base_url: "https://api.example.com/")
      _(subject.base_url).must_equal("https://api.example.com/")
    end

    it "access :access_token option" do
      subject = Dnsimple::Client.new(access_token: "token")
      _(subject.access_token).must_equal("token")
    end

    it "normalizes :base_url trailing slash" do
      subject = Dnsimple::Client.new(base_url: "https://api.example.com/missing/slash")
      _(subject.base_url).must_equal("https://api.example.com/missing/slash/")
    end

    it "defaults :base_url to production API" do
      subject = Dnsimple::Client.new
      _(subject.base_url).must_equal("https://api.dnsimple.com/")
    end
  end

  describe "authentication" do
    it "uses HTTP authentication if there's a password provided" do
      stub_request(:any, %r{/test})

      subject = Dnsimple::Client.new(username: "user", password: "pass")
      subject.execute(:get, "test", {})

      assert_requested(:get, "https://api.dnsimple.com/test", basic_auth: %w[user pass])
    end

    it "uses access token if there's an access token provided" do
      stub_request(:any, %r{/test})

      subject = Dnsimple::Client.new(access_token: "access-token")
      subject.execute(:get, "test", {})

      assert_requested(:get, "https://api.dnsimple.com/test") { |req| req.headers["Authorization"] == "Bearer access-token" }
    end
  end

  describe "#get" do
    it "delegates to #request" do
      subject = Dnsimple::Client.new
      mock = Minitest::Mock.new
      mock.expect(:call, :returned, [:get, "path", nil, { foo: "bar" }])
      subject.stub(:execute, mock) do
        _(subject.get("path", { foo: "bar" })).must_equal(:returned)
      end
      mock.verify
    end
  end

  describe "#post" do
    it "delegates to #request" do
      subject = Dnsimple::Client.new
      mock = Minitest::Mock.new
      mock.expect(:call, :returned, [:post, "path", { foo: "bar" }, {}])
      subject.stub(:execute, mock) do
        _(subject.post("path", { foo: "bar" })).must_equal(:returned)
      end
      mock.verify
    end
  end

  describe "#put" do
    it "delegates to #request" do
      subject = Dnsimple::Client.new
      mock = Minitest::Mock.new
      mock.expect(:call, :returned, [:put, "path", { foo: "bar" }, {}])
      subject.stub(:execute, mock) do
        _(subject.put("path", { foo: "bar" })).must_equal(:returned)
      end
      mock.verify
    end
  end

  describe "#patch" do
    it "delegates to #request" do
      subject = Dnsimple::Client.new
      mock = Minitest::Mock.new
      mock.expect(:call, :returned, [:patch, "path", { foo: "bar" }, {}])
      subject.stub(:execute, mock) do
        _(subject.patch("path", { foo: "bar" })).must_equal(:returned)
      end
      mock.verify
    end
  end

  describe "#delete" do
    it "delegates to #request" do
      subject = Dnsimple::Client.new
      mock = Minitest::Mock.new
      mock.expect(:call, :returned, [:delete, "path", { foo: "bar" }, {}])
      subject.stub(:execute, mock) do
        _(subject.delete("path", { foo: "bar" })).must_equal(:returned)
      end
      mock.verify
    end
  end

  describe "#execute" do
    let(:subject) { Dnsimple::Client.new(username: "user", password: "pass") }

    it "raises RequestError in case of error with a JSON response" do
      stub_request(:post, %r{/foo}).to_return(read_http_fixture("transferDomain/error-indnsimple.http"))

      error = _ {
        subject.execute(:post, "foo", {})
      }.must_raise(Dnsimple::RequestError)
      _(error.message).must_equal("The domain google.com is already in DNSimple and cannot be added")
      _(error.attribute_errors).must_be_nil
    end

    it "raises a Request error in case of an error with a JSON response with attribute errors" do
      stub_request(:post, %r{/foo}).to_return(read_http_fixture("validation-error.http"))

      error = _ {
        subject.execute(:post, "foo", {})
      }.must_raise(Dnsimple::RequestError)
      _(error.message).must_equal("Validation failed")
      _(error).must_respond_to(:attribute_errors)
      _(error.attribute_errors).must_be_kind_of(Hash)
      _(error.attribute_errors["email"]).must_equal(["can't be blank", "is an invalid email address"])
      _(error.attribute_errors["address1"]).must_equal(["can't be blank"])
    end

    it "raises RequestError in case of error with an HTML response" do
      stub_request(:get, %r{/foo}).to_return(read_http_fixture("badgateway.http"))

      error = _ {
        subject.execute(:get, "foo", {})
      }.must_raise(Dnsimple::RequestError)
      _(error.message).must_equal("502 Bad Gateway")
      _(error.attribute_errors).must_be_nil
    end

    it "raises RequestError in absence of content types" do
      stub_request(:put, %r{/foo}).to_return(read_http_fixture("method-not-allowed.http"))

      error = _ {
        subject.execute(:put, "foo", {})
      }.must_raise(Dnsimple::RequestError)
      _(error.message).must_equal("405 Method Not Allowed")
      _(error.attribute_errors).must_be_nil
    end
  end

  describe "#request" do
    let(:subject) { Dnsimple::Client.new(username: "user", password: "pass") }

    it "performs a request" do
      stub_request(:get, %r{/foo})

      subject.request(:get, "foo", {})

      assert_requested(:get, "https://api.dnsimple.com/foo",
                       headers: { "Accept" => "application/json", "User-Agent" => Dnsimple::Default::USER_AGENT },
                       basic_auth: %w[user pass])
    end

    it "delegates to HTTParty" do
      stub_request(:get, %r{/foo})

      subject.request(:get, "foo")

      assert_requested(:get, "https://api.dnsimple.com/foo")
    end

    it "properly extracts processes options and encodes data" do
      stub_request(:put, %r{/foo})

      subject.request(:put, "foo", { something: "else" }, { query: { foo: "bar" }, headers: { "Custom" => "Header" } })

      assert_requested(:put, "https://api.dnsimple.com/foo?foo=bar",
                       body: JSON.dump(something: "else"),
                       headers: { "Accept" => "application/json", "Content-Type" => "application/json", "User-Agent" => Dnsimple::Default::USER_AGENT, "Custom" => "Header" })
    end

    it "handles non application/json content types" do
      stub_request(:post, %r{/foo})

      subject.request(:post, "foo", { something: "else" }, { headers: { "Content-Type" => "application/x-www-form-urlencoded" } })

      assert_requested(:post, "https://api.dnsimple.com/foo",
                       body: { something: "else" },
                       headers: { "Accept" => "application/json", "Content-Type" => "application/x-www-form-urlencoded", "User-Agent" => Dnsimple::Default::USER_AGENT })
    end

    it "includes options for proxy support" do
      stub_request(:get, %r{/test})

      proxy_subject = Dnsimple::Client.new(proxy: "example-proxy.com:4321")
      proxy_subject.request(:get, "test", nil, {})

      assert_requested(:get, "https://api.dnsimple.com/test")
    end

    it "supports custom user agent" do
      stub_request(:get, %r{/test})

      custom_subject = Dnsimple::Client.new(user_agent: "customAgent")
      custom_subject.request(:get, "test", nil)

      assert_requested(:get, "https://api.dnsimple.com/test",
                       headers: { "User-Agent" => "customAgent #{Dnsimple::Default::USER_AGENT}" })
    end
  end

end
