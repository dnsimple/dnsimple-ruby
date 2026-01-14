# frozen_string_literal: true

require "test_helper"

class ClientServiceTest < Minitest::Test

  def test_paginate_loops_all_the_pages
    account_id = 1010
    item_class = Class.new(Dnsimple::Struct::Base) do
      attr_accessor :id
    end

    service_class = Class.new(Dnsimple::Client::ClientService) do
      define_method(:list) do |account_id, options = {}|
        response = client.get(Dnsimple::Client.versioned("/%s/list" % [account_id]), options)
        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| item_class.new(r) })
      end
    end
    subject = service_class.new(Dnsimple::Client.new(base_url: "https://api.example.com/", access_token: "a1b2c3"))

    stub_request(:get, %r{/v2/#{account_id}/list\?page=1&per_page=100})
        .to_return(read_http_fixture("pages-1of3.http"))
    stub_request(:get, %r{/v2/#{account_id}/list\?page=2&per_page=100})
        .to_return(read_http_fixture("pages-2of3.http"))
    stub_request(:get, %r{/v2/#{account_id}/list\?page=3&per_page=100})
        .to_return(read_http_fixture("pages-3of3.http"))

    results = subject.paginate(:list, account_id, {})
    assert_equal(5, results.data.size)
    assert_equal([1, 2, 3, 4, 5], results.data.map(&:id))
  end

end
