require 'spec_helper'

describe Dnsimple::Client do

  describe "class-level configs" do
    before do
      @_1 = described_class.base_uri
      @_2 = described_class.username
      @_3 = described_class.password
      @_4 = described_class.api_token
      @_5 = described_class.domain_api_token
      @_6 = described_class.exchange_token
    end

    after do
      described_class.base_uri          = @_1
      described_class.username          = @_2
      described_class.password          = @_3
      described_class.api_token         = @_4
      described_class.domain_api_token  = @_5
      described_class.exchange_token    = @_6
    end

    it "passes configs to the client" do
      described_class.base_uri         = "https://api.example.com/"
      described_class.username         = "hello"
      described_class.password         = "world"
      described_class.api_token        = "api-token"
      described_class.domain_api_token = "domain-api-token"
      described_class.exchange_token   = "exchange-token"

      expect(described_class).to receive(:new).with({
          api_endpoint: "https://api.example.com/",
          username: "hello",
          password: "world",
          api_token: "api-token",
          domain_api_token: "domain-api-token",
          exchange_token: "exchange-token",
      })

      described_class.client
    end
  end

  [:get, :post, :put, :delete].each do |method|
    describe ".#{method}" do
      it "delegates to .client" do
        client = double()
        expect(client).to receive(method).with('path', { foo: 'bar' })

        expect(described_class).to receive(:client).and_return(client)
        described_class.send(method, 'path', { :foo => 'bar' })
      end
    end
  end

end
