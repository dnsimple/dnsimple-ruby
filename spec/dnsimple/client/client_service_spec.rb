require 'spec_helper'

describe Dnsimple::Client::ClientService do

  describe "#paginate" do
    service_class = Class.new(Dnsimple::Client::ClientService) do
      Item = Class.new(Dnsimple::Struct::Base) do
        attr_accessor :id
      end

      def list(account_id, options = {})
        response = client.get(Dnsimple::Client.versioned("/%s/list" % [account_id]), options)
        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Item.new(r) })
      end
    end

    subject { service_class.new(Dnsimple::Client.new(api_endpoint: "https://api.example.com/", access_token: "a1b2c3")) }

    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r[/v2/#{account_id}/list\?page=1&per_page=100])
          .to_return(read_fixture("pages-1of3.http"))
      stub_request(:get, %r[/v2/#{account_id}/list\?page=2&per_page=100])
          .to_return(read_fixture("pages-2of3.http"))
      stub_request(:get, %r[/v2/#{account_id}/list\?page=3&per_page=100])
          .to_return(read_fixture("pages-3of3.http"))
    end

    it "loops all the pages" do
      results = subject.paginate(:list, account_id, {})
      expect(results.data.size).to eq(5)
      expect(results.data.map(&:id)).to eq([1, 2, 3, 4, 5])
    end
  end

end
