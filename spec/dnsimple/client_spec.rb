require 'spec_helper'

describe DNSimple::Client do
  before :each do
    @username, @password, @api_token = DNSimple::Client.username,
      DNSimple::Client.password, DNSimple::Client.api_token
  end

  after :each do
    DNSimple::Client.username  = @username
    DNSimple::Client.password  = @password
    DNSimple::Client.api_token = @api_token
  end

  [:get, :post, :put, :delete].each do |method|
    describe ".#{method}" do
      let(:response) { stub('response', :code => 200) }

      it "uses HTTP authentication if there's a password provided" do
        DNSimple::Client.username  = 'user'
        DNSimple::Client.password  = 'pass'
        DNSimple::Client.api_token = nil

        HTTParty.expects(method).
          with('http://localhost:3000/domains',
            :format => :json, :headers => {'Accept' => 'application/json'},
            :basic_auth => {:username => 'user', :password => 'pass'}).
          returns(response)

        DNSimple::Client.send(method, 'domains')
      end

      it "uses header authentication if there's an api token provided" do
        DNSimple::Client.username  = 'user'
        DNSimple::Client.password  = nil
        DNSimple::Client.api_token = 'token'

        HTTParty.expects(method).
          with('http://localhost:3000/domains',
            :format => :json, :headers => {'Accept' => 'application/json',
            'X-DNSimple-Token' => 'user:token'}).
          returns(response)

        DNSimple::Client.send(method, 'domains')
      end

      it "raises an error if there's no password or api token provided" do
        DNSimple::Client.username  = 'user'
        DNSimple::Client.password  = nil
        DNSimple::Client.api_token = nil

        lambda {
          DNSimple::Client.send(method, 'domains')
        }.should raise_error(RuntimeError, 'A password or API token is required for all API requests.')
      end
    end
  end
end
