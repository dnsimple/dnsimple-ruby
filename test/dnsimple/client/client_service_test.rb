# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client::ClientService do

  describe "#paginate" do

    let(:account_id) { 1010 }
    let(:service_class) do
      Class.new(Dnsimple::Client::ClientService) do
        Item = Class.new(Dnsimple::Struct::Base) do # rubocop:disable Lint/ConstantDefinitionInBlock
          attr_accessor :id
        end

        def list(account_id, options = {})
          response = client.get(Dnsimple::Client.versioned("/%s/list" % [account_id]), options)
          Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Item.new(r) })
        end
      end
    end
    let(:subject) { service_class.new(Dnsimple::Client.new(base_url: "https://api.example.com/", access_token: "a1b2c3")) }

    before do
      stub_request(:get, %r{/v2/#{account_id}/list\?page=1&per_page=100})
          .to_return(read_http_fixture("pages-1of3.http"))
      stub_request(:get, %r{/v2/#{account_id}/list\?page=2&per_page=100})
          .to_return(read_http_fixture("pages-2of3.http"))
      stub_request(:get, %r{/v2/#{account_id}/list\?page=3&per_page=100})
          .to_return(read_http_fixture("pages-3of3.http"))
    end

    it "loops all the pages" do
      results = subject.paginate(:list, account_id, {})
      _(results.data.size).must_equal(5)
      _(results.data.map(&:id)).must_equal([1, 2, 3, 4, 5])
    end
  end

end
