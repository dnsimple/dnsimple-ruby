# frozen_string_literal: true

module Dnsimple
  class Client
    module DnsAnalytics
      # Queries DNS Analytics data for the provided account
      #
      # @see https://developer.dnsimple.com/v2/dns-analytics#queryDnsAnalytics
      #
      # @param  [Integer] account_id the account ID
      # @param  [Hash] options the filtering, sorting, and grouping options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @option options [Hash] :filter filtering policy
      # @option options [String] :groupings groupings policy
      # @return [Dnsimple::PaginatedResponseWithQuery<Dnsimple::Struct::DnsAnalytics>]
      #
      # @raise  [Dnsimple::RequestError]
      def query(account_id, options = {})
        list_options = Options::ListOptions.new(options)
        response = client.get(Client.versioned("/%s/dns_analytics" % [account_id]), list_options)

        Dnsimple::PaginatedResponseWithQuery.new(response, response["data"]["rows"].map { |row| Struct::DnsAnalytics.new(response["data"]["headers"].zip(row)) })
      end
    end
  end
end
