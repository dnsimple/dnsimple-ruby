require 'spec_helper'

describe Dnsimple::Client do

  describe "initialization" do
    it "accepts :base_url option" do
      subject = described_class.new(base_url: "https://api.example.com/")
      expect(subject.base_url).to eq("https://api.example.com/")
    end

    it "access :access_token option" do
      subject = described_class.new(access_token: "token")
      expect(subject.access_token).to eq("token")
    end

    it "normalizes :base_url trailing slash" do
      subject = described_class.new(base_url: "https://api.example.com/missing/slash")
      expect(subject.base_url).to eq("https://api.example.com/missing/slash/")
    end

    it "defaults :base_url to production API" do
      subject = described_class.new
      expect(subject.base_url).to eq("https://api.dnsimple.com/")
    end
  end

  describe "authentication" do
    it "uses HTTP authentication if there's a password provided" do
      stub_request(:any, %r{/test})

      subject = described_class.new(username: "user", password: "pass")
      subject.execute(:get, "test", {})

      expect(WebMock).to have_requested(:get, "https://user:pass@api.dnsimple.com/test")
    end

    it "uses access token if there's an access token provided" do
      stub_request(:any, %r{/test})

      subject = described_class.new(access_token: "access-token")
      subject.execute(:get, "test", {})

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.com/test").
          with { |req| req.headers["Authorization"] == "Bearer access-token" }
    end

    it "raises an error if there's no password, domain token or access token provided" do
      subject = described_class.new(username: "user", oauth_client_id: "id", oauth_client_secret: "secret")

      expect {
        subject.execute(:get, "test", {})
      }.to raise_error(Dnsimple::Error, "A password, domain API token or access token is required.")
    end

    it "can perform requests without requiring authentication" do
      stub_request(:any, %r{/test})

      expect {
        subject.execute(:get, "test", nil, authenticate: false)
      }.not_to raise_error
    end
  end

  describe "#get" do
    it "delegates to #request" do
      expect(subject).to receive(:execute).with(:get, "path", nil, foo: "bar").and_return(:returned)
      expect(subject.get("path", foo: "bar")).to eq(:returned)
    end
  end

  describe "#post" do
    it "delegates to #request" do
      expect(subject).to receive(:execute).with(:post, "path", { foo: "bar" }, {}).and_return(:returned)
      expect(subject.post("path", foo: "bar")).to eq(:returned)
    end
  end

  describe "#put" do
    it "delegates to #request" do
      expect(subject).to receive(:execute).with(:put, "path", { foo: "bar" }, {}).and_return(:returned)
      expect(subject.put("path", foo: "bar")).to eq(:returned)
    end
  end

  describe "#patch" do
    it "delegates to #request" do
      expect(subject).to receive(:execute).with(:patch, "path", { foo: "bar" }, {}).and_return(:returned)
      expect(subject.patch("path", foo: "bar")).to eq(:returned)
    end
  end

  describe "#delete" do
    it "delegates to #request" do
      expect(subject).to receive(:execute).with(:delete, "path", { foo: "bar" }, {}).and_return(:returned)
      expect(subject.delete("path", foo: "bar")).to eq(:returned)
    end
  end

  describe "#execute" do
    subject { described_class.new(username: "user", password: "pass") }

    it "raises RequestError in case of error with a JSON response" do
      stub_request(:post, %r{/foo}).to_return(read_http_fixture("transferDomain/error-indnsimple.http"))

      expect {
        subject.execute(:post, "foo", {})
      }.to raise_error(Dnsimple::RequestError, "The domain google.com is already in DNSimple and cannot be added")
    end

    it "raises RequestError in case of error with an HTML response" do
      stub_request(:get, %r{/foo}).to_return(read_http_fixture("badgateway.http"))

      expect {
        subject.execute(:get, "foo", {})
      }.to raise_error(Dnsimple::RequestError, "502 Bad Gateway")
    end

    it "raises RequestError in absence of content types" do
      stub_request(:put, %r{/foo}).to_return(read_http_fixture("method-not-allowed.http"))

      expect {
        subject.execute(:put, "foo", {})
      }.to raise_error(Dnsimple::RequestError, "405 Method Not Allowed")
    end
  end

  describe "#request" do
    subject { described_class.new(username: "user", password: "pass") }

    it "performs a request" do
      stub_request(:get, %r{/foo})

      subject.request(:get, 'foo', {})

      expect(WebMock).to have_requested(:get, "https://user:pass@api.dnsimple.com/foo").
          with(headers: { 'Accept' => 'application/json', 'User-Agent' => "dnsimple-ruby/#{Dnsimple::VERSION}" })
    end

    it "delegates to HTTParty" do
      stub_request(:get, %r{/foo})

      expect(HTTParty).to receive(:get).
          with(
              "#{subject.base_url}foo",
              format: :json,
              basic_auth: { username: "user", password: "pass" },
              headers: { 'Accept' => 'application/json', 'User-Agent' => "dnsimple-ruby/#{Dnsimple::VERSION}" }
          ).
          and_return(double('response', code: 200))

      subject.request(:get, 'foo')
    end

    it "properly extracts processes options and encodes data" do
      expect(HTTParty).to receive(:put).
          with(
              "#{subject.base_url}foo",
              format: :json,
              body: JSON.dump(something: "else"),
              query: { foo: "bar" },
              basic_auth: { username: "user", password: "pass" },
              headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json', 'User-Agent' => "dnsimple-ruby/#{Dnsimple::VERSION}", "Custom" => "Header" }
          ).
          and_return(double('response', code: 200))

      subject.request(:put, 'foo', { something: "else" }, { query: { foo: "bar" }, headers: { "Custom" => "Header" } })
    end

    it "handles non application/json content types" do
      expect(HTTParty).to receive(:post).
          with(
              "#{subject.base_url}foo",
              format: :json,
              body: { something: "else" },
              basic_auth: { username: "user", password: "pass" },
              headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/x-www-form-urlencoded', 'User-Agent' => "dnsimple-ruby/#{Dnsimple::VERSION}" }
          ).
          and_return(double('response', code: 200))

      subject.request(:post, 'foo', { something: "else" }, { headers: { "Content-Type" => "application/x-www-form-urlencoded" } })
    end

    it "includes options for proxy support" do
      expect(HTTParty).to receive(:get).
          with(
              "#{subject.base_url}test",
              format: :json,
              http_proxyaddr: "example-proxy.com",
              http_proxyport: "4321",
              headers: { 'Accept' => 'application/json', 'User-Agent' => "dnsimple-ruby/#{Dnsimple::VERSION}" }
          ).
          and_return(double('response', code: 200))

      subject = described_class.new(proxy: "example-proxy.com:4321")
      subject.request(:get, "test", nil, authenticate: false)
    end
  end

end
